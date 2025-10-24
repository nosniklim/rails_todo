# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth: Registration', type: :system do
  let(:password) { 'password' }
  # NOTE: ユーザー作成機能をテストするのでcreateではなくbuild
  let!(:new_user) { build(:user) }
  let(:login_page) { LoginPage.new }

  before { RegistrationPage.new.visit! }

  describe 'ログイン成功' do
    it '新規アカウントを作成したらトップページに遷移すること' do
      RegistrationPage.new.sign_up(
        name: new_user.name, email: new_user.email,
        password: password, password_confirmation: password
      )

      expect(page).to have_current_path(root_path)
      # ヘッダーが表示されることを確認
      user = User.find_by(email: new_user.email)
      expect(page).to have_selector('.header_menu')
      expect(page).to have_link(user.name, href: edit_user_path(user))
      expect(page).to have_link('Todolist', href: root_path)
      expect(page).to have_link('New List', href: new_list_path)
      expect(page).to have_link('Sign out', href: destroy_user_session_path)
    end
  end

  describe 'ログイン失敗' do
    describe 'アカウント作成時の不正な入力値の検証' do
      describe 'name' do
        it '名前が短すぎる場合はエラーを表示し、入力値（password以外）を保持して再表示' do
          short_name = 'a' # 2文字未満
          RegistrationPage.new.sign_up(
            name: short_name, email: new_user.email,
            password: password, password_confirmation: password
          )
          expect(page).to have_content('Name is too short')
          expect(page).to have_current_path(user_registration_path)
          expect(page).to have_field('Name', with: short_name)
          expect(page).to have_field('Email', with: new_user.email)
          expect(login_page.password_value).to be_nil
        end

        it '名前が未入力の場合はエラーを表示し、入力値（password以外）を保持して再表示' do
          RegistrationPage.new.sign_up(
            name: '', email: new_user.email,
            password: password, password_confirmation: password
          )
          expect(page).to have_content("Name can't be blank")
          expect(page).to have_current_path(user_registration_path)
          expect(page).to have_field('Name', with: '')
          expect(page).to have_field('Email', with: new_user.email)
          expect(login_page.password_value).to be_nil
        end
      end

      describe 'email' do
        it 'emailが不正なフォーマットの場合はエラーを表示し、入力値（password以外）を保持して再表示' do
          RegistrationPage.new.sign_up(
            name: new_user.name, email: 'invalid_email',
            password: password, password_confirmation: password
          )
          expect(page).to have_content('Email is invalid')
          expect(page).to have_current_path(user_registration_path)
          expect(page).to have_field('Name', with: new_user.name)
          expect(page).to have_field('Email', with: 'invalid_email')
          expect(login_page.password_value).to be_nil
        end
      end

      describe 'password' do
        it 'パスワードが短すぎる場合はエラーを表示し、入力値（password以外）を保持して再表示' do
          RegistrationPage.new.sign_up(
            name: new_user.name, email: new_user.email,
            password: '12345', password_confirmation: '12345'
          )
          expect(page).to have_content('Password is too short')
          expect(page).to have_current_path(user_registration_path)
          expect(page).to have_field('Name', with: new_user.name)
          expect(page).to have_field('Email', with: new_user.email)
          expect(login_page.password_value).to be_nil
        end
      end

      describe 'password_confirmation' do
        it '確認用パスワードが一致しない場合はエラーを表示し、入力値（password以外）を保持して再表示' do
          RegistrationPage.new.sign_up(
            name: new_user.name, email: new_user.email,
            password: password, password_confirmation: 'different_password'
          )
          expect(page).to have_content("Password confirmation doesn't match Password")
          expect(page).to have_current_path(user_registration_path)
          expect(page).to have_field('Name', with: new_user.name)
          expect(page).to have_field('Email', with: new_user.email)
          expect(login_page.password_value).to be_nil
        end
      end
    end
  end
end
