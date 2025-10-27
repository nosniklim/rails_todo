# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards: Create', type: :system do
  let(:password)  { 'password' }
  let!(:user)     { create(:user, password: password, password_confirmation: password) }
  let(:card_form) { CardFormPage.new }
  let(:top_page)  { TopPage.new }

  # Lists
  let!(:list_a)  { create(:list, user: user, title: 'A', position: 1) }
  let!(:list_b)  { create(:list, user: user, title: 'B', position: 2) }

   # Cards
   let!(:card_a1) { create(:card, list: list_a, title: 'Task A1', memo: 'Memo A1', position: 1) }

  before { sign_in_as(user) }

  describe '画面表示' do
    it '表示内容が正しいこと' do
      visit new_list_card_path(list_a)
      expect(page).to have_selector('label', text: 'Title')
      expect(page).to have_selector('label', text: 'Add Comment')
      # TODO: [data-testid="input-card-title"]
      expect(find('input#card_title')[:placeholder]).to eq('Add a card...')
      # TODO: [data-testid="input-card-memo"]
      expect(find('textarea#card_memo')[:placeholder]).to eq('Write a comment...')
      expect(page).to have_button('Create')
    end
  end

  describe '作成成功' do
    it 'タイトルを入力してCreateでトップページに遷移し、対象リストの末尾にカードが表示されること' do
      visit new_list_card_path(list_a)
      card_form.fill_title('Task A2')
      card_form.fill_memo('Memo A2')
      click_button 'Create'

      expect(page).to have_current_path(root_path)

      top_page.within_list('A') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A1', 'Task A2']
      end
    end

    it 'トップページのリンク経由でも作成できる' do
      visit root_path
      # TODO: [data-testid="link-add-card"]
      top_page.within_list('B') { find('.addCard_link', text: 'Add a card...').click }

      card_form.fill_title('Task From Link')
      click_button 'Create'

      expect(page).to have_current_path(root_path)
      top_page.within_list('B') do
        # TODO: [data-testid="card-title"]
        expect(page).to have_selector('.card_title', text: 'Task From Link')
      end
    end
  end

  describe '作成失敗' do
    it 'タイトル未入力で保存すると、入力値を保持して同画面を再表示' do
      visit new_list_card_path(list_a)

      card_form.fill_title('')
      card_form.fill_memo('keep me')
      click_button 'Create'

      # 失敗（編集画面に留まる）
      # FIXME: createでrender :newしてるからなのかnew_list_card_pathから遷移してしまっている
      expect(page).to have_current_path(list_card_index_path(list_a))

      # エラーメッセージ
      # TODO: [data-testid="form-error"], [data-testid="flash"]
      expect(page).to have_selector('.text-danger')

      # 入力保持の確認
      expect(page).to have_field('card_title', with: '')
      expect(page).to have_field('card_memo', with: 'keep me')
    end
  end
end
