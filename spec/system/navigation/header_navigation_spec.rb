# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation: Global Header', type: :system do
  let(:password) { 'password' }

  # 遷移先ページを準備しておく
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:list) { create(:list, user: user, title: 'Todo', position: 1) }
  let!(:card) { create(:card, list: list, title: 'Task A', position: 1) }

  # ヘッダーを表示するページ
  let(:pages) do
    [
      [:top,        -> { root_path }],
      [:list_new,   -> { new_list_path }],
      [:list_edit,  -> { edit_list_path(list) }],
      [:card_show,  -> { list_card_path(list, card) }],
      [:card_new,   -> { new_list_card_path(list) }],
      [:card_edit,  -> { edit_list_card_path(list, card) }],
      [:user_edit,  -> { edit_user_path(user) }]
    ]
  end

  before do
    sign_in_as(user)
  end

  describe 'グローバルヘッダー' do
    it '主要ページでヘッダーメニューが常に表示されること' do
      pages.each do |(_name, path_lambda)|
        visit path_lambda.call
        # ヘッダーが表示されることを確認
        expect(page).to have_selector('.header_menu')
        expect(page).to have_link(user.name, href: edit_user_path(user))
        expect(page).to have_link('Todolist', href: root_path)
        expect(page).to have_link('New List', href: new_list_path)
        expect(page).to have_link('Sign out', href: destroy_user_session_path)
      end
    end
  end

  describe 'ヘッダーリンクの遷移設定' do
    before { visit edit_list_path(list) } # :top 以外の任意のページ

    let(:header) { Header.new(user.name) }

    it 'ユーザー名 リンクでユーザー編集ページへ遷移' do
      header.goto_user_edit
      expect(page).to have_current_path(edit_user_path(user))
    end

    it 'ホーム リンクでトップページへ遷移' do
      header.goto_home
      expect(page).to have_current_path(root_path)
    end

    it 'New List リンクでリスト作成ページへ遷移' do
      header.goto_new_list
      expect(page).to have_current_path(new_list_path)
    end

    it 'Sign out リンクでサインアウト' do
      header.sign_out
      # TODO: [data-testid="link-sign-out"]
      expect(page).to have_current_path(new_user_session_path).or have_no_selector('.header_menu_inner .nav-link', text: 'Sign out')
    end
  end

  describe 'サインアウト後の表示' do
    it 'サインアウト後はヘッダーメニューが表示されない' do
      visit root_path
      Header.new.sign_out
      expect(page).to have_current_path(new_user_session_path)
      # ヘッダーが表示されないことを確認
      expect(page).not_to have_selector('.header_menu')
      expect(page).not_to have_link(user.name, href: edit_user_path(user))
      expect(page).not_to have_link('Todolist', href: root_path)
      expect(page).not_to have_link('New List', href: new_list_path)
      expect(page).not_to have_link('Sign out', href: destroy_user_session_path)
    end
  end
end
