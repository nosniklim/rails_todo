# frozen_string_literal: true

require 'capybara'

Capybara.default_max_wait_time = 3
Capybara.server = :puma, { Silent: true } # Pumaサーバーを使用
Capybara.app_host = "http://app:3000"

# Seleniumの設定を登録
Capybara.register_driver :selenium_remote_chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://#{ENV.fetch('SELENIUM_HOST', 'localhost')}:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions' => { 'args' => %w[headless disable-gpu no-sandbox disable-dev-shm-usage window-size=1920,1080] }
    )
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_remote_chrome
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
