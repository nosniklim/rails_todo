# frozen_string_literal: true

class Header
  include Capybara::DSL

  def initialize(user_name = 'Test User')
    @user_name = user_name
  end

  def goto_user_edit
    # TODO: [data-testid="link-user-edit"]
    find('.header_menu_user .nav-link', text: @user_name).click
  end

  def goto_home
    # TODO: [data-testid="link-home"]
    find('.header_menu_title .nav-link', text: 'Todolist').click
  end

  def goto_new_list
    # TODO: [data-testid="link-new-list"]
    find('.header_menu_inner .nav-link', text: 'New List').click
  end

  def sign_out
    # TODO: [data-testid="link-sign-out"]
    find('.header_menu_inner .nav-link', text: 'Sign out').click
  end
end
