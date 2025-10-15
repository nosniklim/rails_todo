# frozen_string_literal: true

require 'capybara'

Capybara.default_max_wait_time = 3

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome
  end

  config.after(:each, type: :system) do |example|
    if example.exception
      FileUtils.mkdir_p('tmp/capybara')
      base_path = "tmp/capybara/#{example.full_description.parameterize}"
      page.save_screenshot("#{base_path}.png", full: true)
      save_page("#{base_path}.html")
    end
  end
end
