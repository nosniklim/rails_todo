# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication base', type: :system do
  let(:user) { create(:user, password: 'password') }

  it 'ログインしてトップページに遷移すること' do
    LoginPage.new.visit!.login(name: user.name, password: 'password')
    expect(page).to have_current_path(root_path)
    expect(page).to have_selector('.header_menu')
    expect(page).to have_link(user.name, href: edit_user_path(user))
    expect(page).to have_link('Todolist', href: root_path)
    expect(page).to have_link('New List', href: new_list_path)
    expect(page).to have_link('Sign out', href: destroy_user_session_path)
  end
end
