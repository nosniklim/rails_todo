# frozen_string_literal: true

require 'capybara/rspec'

class LoginPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit!
    visit new_user_session_path
    self
  end

  def login(name:, password:)
    fill_in 'Name', with: name
    fill_in 'Password', with: password
    click_button 'Sign in'
    self
  end

  def password_value
    find_field('Password').value
  end
end
