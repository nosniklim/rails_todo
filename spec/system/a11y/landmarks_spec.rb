# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A11y: Landmarks', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let!(:list)    { create(:list, user: user, title: 'Todo', position: 1) }
  let!(:card)    { create(:card, list: list, title: 'Task A', position: 1) }

  # ランドマークを確認するページ
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

  before { sign_in_as(user) }

  it '各ページにグローバルナビが1つだけ存在すること' do
    pages.each do |(name, path_lambda)|
      visit path_lambda.call

      aggregate_failures("landmarks on #{name}") do
        # FIXME: SEO対策の参考のため残しておく
        # h1 は原則1つ
        # expect(page).to have_selector('h1', count: 1)

        # FIXME: SPA未実装のためpending
        # main は1つ（SPA等で2つ以上になる場合は要調整）
        # expect(page).to have_selector('[role="main"]', count: 1)

        # グローバルナビは1つ
        expect(page).to have_selector('.header', count: 1)

        # サービス名の表示は1つ
        expect(page).to have_selector('.header_menu_title', text: 'Todolist', count: 1)

        # リスト表示エリア
        if name == :top
          # トップページにはリスト表示エリアが1つある
          expect(page).to have_selector('.listWrapper', count: 1)
        else
          # トップページ以外にはリスト表示エリアがない
          expect(page).to have_no_selector('.listWrapper')
        end
      end
    end
  end

  context '多重main回避' do
    it 'main が2つ以上存在しないこと' do
      pending 'SPA実装時に役に立つかも知れないので残しておく'
      visit root_path
      expect(page).to have_selector('[role="main"]', count: 1)
    end
  end
end
