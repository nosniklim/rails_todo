# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards: Delete', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let(:top_page) { TopPage.new }

  # Lists
  let!(:list_a)  { create(:list, user: user, title: 'A', position: 1) }

  # Cards
  let!(:card_1)      { create(:card, list: list_a, title: 'Task A1', position: 1) }
  let!(:card_2)      { create(:card, list: list_a, title: 'Task A2', position: 2) }

  before { sign_in_as(user) }

  before { visit list_card_path(list_a, card_1) }

  it '削除リンクをクリックすると確認メッセージが表示され、トップページから削除される' do
    find('a[data-confirm="Are you sure you want to remove this card?"]').click
    expect(page).to have_current_path(root_path)

    top_page.within_list('A') do
      # TODO: [data-testid="card-title"]
      expect(page).to have_no_selector('.card_title', text: 'Task A1')
      expect(all('.card_title').map(&:text)).to eq ['Task A2']
    end

    # positionが更新されていることを確認
    expect(Card.where(list: list_a).order(:position).pluck(:title)).to eq ['Task A2']
    expect(Card.where(list: list_a).order(:position).pluck(:position)).to eq [1]
  end

  # it 'confirmをキャンセルすると削除されない', js: true do
  it 'confirmをキャンセルすると削除されない' do
    pending 'FIXME: 新規作成ユーザーでログインできないSeleniumの問題が未解決なのでJSを使用できない'
    page.dismiss_confirm do
      find('a[data-confirm="Are you sure you want to remove this card?"]').click
    end
    expect(page).to have_current_path(root_path)

    # TODO: [data-testid="card-title"]
    expect(all('.card_title').map(&:text)).to eq ['Task A1', 'Task A2']
  end
end
