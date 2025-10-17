# frozen_string_literal: true

class Header
  include Capybara::DSL

  def initialize(user_name = 'Test User')
    @user_name = user_name
  end

  def goto_user_edit
    find('.header_menu_user .nav-link', text: @user_name).click
  end

  def goto_home
    find('.header_menu_title .nav-link', text: 'Todolist').click
  end

  def goto_new_list
    find('.header_menu_inner .nav-link', text: 'New List').click
  end

  def sign_out
    find('.header_menu_inner .nav-link', text: 'Sign out').click
  end
end
