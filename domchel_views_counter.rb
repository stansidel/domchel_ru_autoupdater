#!/usr/bin/env ruby
require File.expand_path('shared.rb')
require 'csv'

module DomchelInteraction
  class ViewsCounter
    include Capybara::DSL
    include DomchelInteraction::CommonActions

    VIEWS_RECORDS_FILE = 'views_info.csv'

    def save_views_count
      domchel_login
      visit_domchel_messages
      table_row = first('tr[id*="row"]')
      view_info = {}
      view_info[:datetime] = Time.now
      view_info[:message_id] = table_row.first('td').text
      view_info[:price] = table_row.first('td:nth-of-type(5)').text.gsub(/\s+/, '')
      view_info[:views] = table_row.first('td:nth-of-type(9) strong').text.gsub(/\s+/, '')
      puts view_info
      write_views_record(view_info)
    end

    private

    def write_views_record(info)
      file = File.expand_path(VIEWS_RECORDS_FILE)
      csv_options = { col_sep: ';', force_quotes: true }
      unless File.exists? file
        CSV.open(file, 'wb', csv_options) { |csv| csv << info.keys }
      end
      CSV.open(file, 'ab', csv_options) { |csv| csv << info.values }
    end
  end
end

counter = DomchelInteraction::ViewsCounter.new
counter.save_views_count

