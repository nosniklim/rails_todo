# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lists: Delete', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }

  let!(:list1) { create(:list, user: user, title: 'Todo',  position: 1) }
  let!(:list2) { create(:list, user: user, title: 'Doing', position: 2) }
  let!(:list3) { create(:list, user: user, title: 'Done',  position: 3) }

  before do
    sign_in_as(user)
    visit root_path
  end

  it '削除アイコンをクリックすると確認メッセージが表示され、トップページから削除される' do
    within('.list_header', text: 'Doing') do
      find('a[data-confirm="Are you sure you want to remove \'Doing\'?"]').click
    end
    expect(page).to have_current_path(root_path)

    # リストの表示順が変更されていることを確認
    # TODO: [data-testid="list-title"]
    titles = all('.list_header_title').map(&:text)
    expect(titles).to eq %w[Todo Done]
    expect(page).to have_no_selector('.list_header_title', text: 'Doing')

    # positionが更新されていることを確認
    expect(List.where(user: user).order(:position).pluck(:title)).to eq %w[Todo Done]
    expect(List.where(user: user).order(:position).pluck(:position)).to eq [1, 2]
  end

  it 'confirmをキャンセルすると削除されない', js: true do
    within('.list_header', text: 'Doing') do
      page.dismiss_confirm do
        find('a[data-confirm="Are you sure you want to remove \'Doing\'?"]').click
      end
    end
    expect(page).to have_current_path(root_path)

    # TODO: [data-testid="list-title"]
    titles = all('.list_header_title').map(&:text)
    expect(titles).to eq %w[Todo Doing Done]
  end
end
