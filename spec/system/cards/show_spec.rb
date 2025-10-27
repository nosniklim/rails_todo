# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards: Show', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let(:card_show_page) { CardShowPage.new }

  let!(:list_a) { create(:list, user: user, title: 'A', position: 1) }
  let!(:card_a1) { create(:card, list: list_a, title: 'Task A1', memo: 'Memo A1', position: 1) }

  before do
    sign_in_as(user)
    visit list_card_path(list_a, card_a1)
  end

  describe '画面表示' do
    it '表示内容が正しいこと' do
      expect(page).to have_selector('.cardContents_title', text: 'Title')
      expect(page).to have_selector('.cardContents_memo', text: 'Memo')
      expect(page).to have_selector('.cardContents_list', text: 'List')
      expect(page).to have_selector('.cardContents_position', text: 'Position')

      # TODO: [data-testid="input-card-title"]
      expect(page).to have_selector('.cardContents_title h2', text: 'Task A1', wait: 1)
      # TODO: [data-testid="input-card-memo"]
      expect(page).to have_selector('.cardContents_memo div', text: 'Memo A1', wait: 1)
      # TODO: [data-testid="select-card-list"]
      expect(page).to have_selector('.cardContents_list div', text: 'A', wait: 1)
      # TODO: [data-testid="select-card-position"]
      expect(page).to have_selector('.cardContents_position div', text: '1', wait: 1)
    end

    it '編集リンクが表示されている' do
      # TODO: [data-testid="link-card-edit"]
      expect(page).to have_selector('.edit_btn', text: 'Edit')
    end

    it '削除リンクが表示されている' do
      # TODO: [data-testid="link-card-remove"]
      expect(page).to have_selector('.delete_btn', text: 'Remove')
    end
  end

  describe '編集ページへリンク' do
    it '編集リンクをクリックするとカード編集ページへ遷移する' do
      # TODO: [data-testid="link-card-edit"]
      find('.edit_btn', text: 'Edit').click
      expect(page).to have_current_path(edit_list_card_path(list_a, card_a1))

      card_show_page.have_title?('Task A1')
      card_show_page.have_memo?('Memo A1')
      card_show_page.have_list?('A')
      card_show_page.have_position?(1)
    end
  end

  # NOTE: 削除リンクは cards/delete_spec.rb で確認
end
