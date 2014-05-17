#!/usr/bin/env ruby
require File.expand_path('shared.rb')

module DomchelInteraction
  class MessageUpdater
    include Capybara::DSL
    include DomchelInteraction::CommonActions

    LAST_UPDATED_FILENAME = '.last_updated'
    REPORT_TO_EMAILS = ENV['DOMCHEL_REPORT_TO_EMAILS']
    UPDATES_INTERVAL = 60 * 60 * 24  # 24 hours
    
    def update_first
      return 3 unless need_update?
      domchel_login
      visit_domchel_messages
      page.execute_script('$("tr[id*=\'row\']").trigger("mouseover")')
      find('img[src*="prolong"]').first(:xpath, './/..').click
      if page.has_content? 'Обновлено (поднято в списке) объявлений: 1'
        notify_updated
        return 0
      else
        puts page.first('#errors_sell_land_housing').text
        return 2
      end
    end

    private

    def notify_updated
      update_time = Time.now
      File.open(File.expand_path(LAST_UPDATED_FILENAME), 'w') { |f| f.write(update_time)  }
      `echo "Domchel message was updated on #{update_time}." | mail -s "Domchel message updated" #{REPORT_TO_EMAILS}`
    end

    def need_update?
      file = File.expand_path(LAST_UPDATED_FILENAME)
      if File.exists? file
        begin
          time = Time.parse(File.read(file))
        rescue
          return true
        end
        return Time.now - time >= UPDATES_INTERVAL
      end
      return true
    end
  end
end

t = DomchelInteraction::MessageUpdater.new
result = t.update_first
puts result
File.open(File.expand_path('.last_run'), 'w') { |f| f.write("Last run on #{Time.now} returned status code #{result}") }
exit result

