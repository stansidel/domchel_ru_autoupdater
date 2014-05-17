require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
#Capybara.current_driver = :selenium
Capybara.current_driver = :poltergeist
#Capybara.javascript_driver = :poltergeist
Capybara.app_host = 'http://domchel.ru'
Capybara.default_wait_time = 5

module DomchelInteraction
  module CommonActions
    def domchel_login
      visit('/')
      click_link 'Вход'
      fill_in 'Электронная почта', with: ENV['DOMCHEL_EMAIL']
      fill_in 'Пароль', with: ENV['DOMCHEL_PASSWORD']
      click_button 'Вход'
      unless page.has_content? 'Мои сообщения'
        puts 'Unable to authorize'
        return 1
      end
    end

    def visit_domchel_messages
      click_link 'Моя страница'
      click_link 'Моя недвижимость'
    end
  end
end

