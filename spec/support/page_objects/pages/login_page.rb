# frozen_string_literal: true

class LoginPage
  include Capybara::DSL

  def visit!
    visit new_user_session_path
    self
  end

  def login(name:, password:)
    fill_in 'Name', with: name
    fill_in 'Password', with: password
    click_button 'Log in'
    self
  end
end
