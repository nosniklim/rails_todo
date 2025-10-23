# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth: Login', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let(:login_page) { LoginPage.new }

  before { LoginPage.new.visit! }

  describe 'ログイン成功' do
    it 'name + password でログインしてトップページに遷移すること' do
      login_page.login(name: user.name, password: password)
      expect(page).to have_current_path(root_path)
      expect(page).to have_selector('.header_menu')
      expect(page).to have_link(user.name, href: edit_user_path(user))
      expect(page).to have_link('Todolist', href: root_path)
      expect(page).to have_link('New List', href: new_list_path)
      expect(page).to have_link('Sign out', href: destroy_user_session_path)
    end
  end

  describe 'ログイン失敗' do
    it 'パスワードを間違えた場合はエラーが表示されること' do
      login_page.login(name: user.name, password: 'wrong-pass')
      # 失敗した時はログイン画面を再表示
      expect(page).to have_current_path(new_user_session_path)
      # エラーメッセージ
      # TODO: [data-testid="form-error"], [data-testid="flash"]
      expect(page).to have_selector('.alert.alert-danger')
      # name は保持、password は空欄
      expect(page).to have_field('Name', with: user.name)
      expect(login_page.password_value).to be_nil
    end
  end
end
