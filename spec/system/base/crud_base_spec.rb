# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CRUD base', type: :system do
  let(:user) { create(:user, password: 'password') }

  it 'basic CRUD operations on list and card' do
    sign_in_as(user)

    # Create List
    Header.new.goto_new_list
    ListFormPage.new.create(title: 'Todo')
    expect(page).to have_content('Todo')

    # Create Card and Edit Card
    TopPage.new.add_card_to('Todo', title: 'Task 1', memo: 'first')
    click_link 'Task 1'
    expect(page).to have_content('Task 1')
    click_link 'Edit'
    CardFormPage.new.update(title: 'Task 9', memo: 'last')
    expect(page).to have_content('Task 9')

    # Edit List
    # NOTE: リスト詳細ページへのリンクはテキストが表示されないためCSSセレクタを指定
    within('.list_header', text: 'Todo') do
      find('a[href*="/list/"][href$="/edit"]').click
    end
    ListFormPage.new.update(title: 'Done')
    expect(page).to have_content('Done')
  end
end
