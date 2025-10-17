# frozen_string_literal: true

class Header
  include Capybara::DSL

  def goto_user_edit
    find('.nav-link', text: current_user_name).click
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

  private

  def current_user_name
    current_user&.name || 'Test User'
  end
end
