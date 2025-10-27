# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lists: Create', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let(:list_form) { ListFormPage.new }

  before do
    sign_in_as(user)
    visit new_list_path
  end

  describe '画面表示' do
    it '表示内容が正しいこと' do
      expect(page).to have_selector('label', text: 'Title')
      # TODO: [data-testid="input-list-title"]
      expect(find('input#list_title')[:placeholder]).to eq('Add a list...')
      expect(page).to have_button('Create')
    end
  end

  describe '作成成功' do
    it 'タイトルを入力してCreateでトップページに遷移すること' do
      list_form.fill_title('Todo')
      click_button 'Create'
      expect(page).to have_current_path(root_path)

      # タイトルが表示されていることを確認
      # TODO: [data-testid="board"]
      within('.listWrapper') do
        # TODO: [data-testid="list-title"]
        expect(page).to have_selector('.list_header_title', text: 'Todo')
      end
    end
  end

  describe '作成失敗' do
    it 'タイトル未入力で保存すると、入力値を保持して同画面を再表示' do
      list_form.fill_title('')
      click_button 'Create'

      # 失敗（作成画面に留まる）
      # NOTE: リダイレクトせずrender :newしてるためcreateアクションのパスが表示される
      expect(page).to have_current_path(list_index_path)

      # エラーメッセージ
      # TODO: [data-testid="form-error"], [data-testid="flash"]
      expect(page).to have_selector('.text-danger', text: 'Title must be less than 255 characters.')

      # 入力保持の確認
      expect(page).to have_field('Title', with: '')
    end
  end
end
