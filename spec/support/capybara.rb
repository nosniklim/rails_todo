# frozen_string_literal: true

require 'capybara'

Capybara.default_max_wait_time = 3
Capybara.server = :puma, { Silent: true } # Pumaサーバーを使用
Capybara.app_host = 'http://app:3000'
Capybara.save_path = 'tmp/capybara'

# Seleniumの設定を登録
Capybara.register_driver :selenium_remote_chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('headless')
  chrome_options.add_argument('disable-gpu')
  chrome_options.add_argument('no-sandbox')
  chrome_options.add_argument('disable-dev-shm-usage')
  chrome_options.add_argument('window-size=1920,1080')
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "http://#{ENV.fetch('SELENIUM_HOST', 'localhost')}:4444/wd/hub",
                                 options: chrome_options)
end

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :rack_test }
  config.before(:each, type: :system, js: true) { driven_by :selenium_remote_chrome }

  config.after(:each, type: :system) do |example|
    if example.exception
      FileUtils.mkdir_p('tmp/capybara')
      timestamp = Time.current.strftime('%Y%m%d-%H%M%S')
      base_path = "#{example.full_description.parameterize}-#{timestamp}"
      page.save_screenshot("#{base_path}.png", full: true)
      save_page("#{base_path}.html")
    end
  end
end
