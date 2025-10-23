# frozen_string_literal: true

class RegistrationPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit!
    visit new_user_registration_path
    self
  end

  def sign_up(name:, email:, password:, password_confirmation: password)
    fill_name(name)
    fill_email(email)
    fill_password(password)
    fill_password_confirmation(password_confirmation)
    submit('Create Account')
  end

  # --- primitives ---

  # fill_in 'Name', with: val
  def fill_name(name)
    # TODO: [data-testid="input-user-name"]
    fill_in 'Name', with: name
  end

  # fill_in 'Email', with: val
  def fill_email(email)
    # TODO: [data-testid="input-user-email"]
    fill_in 'Email', with: email
  end

  # fill_in 'Password', with: val
  def fill_password(password)
    # TODO: [data-testid="input-user-password"]
    fill_in 'Password', with: password
  end

  # fill_in 'Password confirmation', with: val
  def fill_password_confirmation(password)
    # TODO: [data-testid="input-user-password-confirmation"]
    fill_in 'Password confirmation', with: password
  end

  # click_button(button_text)
  def submit(button_text = 'Create Account')
    # TODO: [data-testid="btn-submit-registration"]
    click_button(button_text)
  end

  # --- assertions helpers ---

  def have_error?(text)
    # TODO: [data-testid="form-error"]
    page.has_selector?('.alert.alert-danger', text: text)
  end

  def have_flash?(text)
    # TODO: [data-testid="flash"]
    page.has_selector?('.alert.alert-info', text: text)
  end
end
