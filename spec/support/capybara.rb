# frozen_string_literal: true

require 'capybara'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome
  end

  Capybara.default_max_wait_time = 3

  config.after(:each, type: :system) do |example|
    if example.exception
      FileUtils.mkdir_p('tmp/capybara')
      page.save_screenshot("tmp/capybara/#{example.full_description.parameterize}.png", full: true)
      save_page("tmp/capybara/#{example.full_description.parameterize}.html")
    end
  end
end
