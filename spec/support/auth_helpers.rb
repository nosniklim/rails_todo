# frozen_string_literal: true

module AuthHelpers
  def sign_in_as(user)
    LoginPage.new.visit!.login(name: user.name, password: 'password')
  end
end
RSpec.configure { |c| c.include AuthHelpers, type: :system }
