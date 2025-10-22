# frozen_string_literal: true

require 'capybara/rspec'

class CardFormPage
  include Capybara::DSL

  def create(title:, memo: nil)
    fill_title(title)
    fill_memo(memo) if memo
    submit('Create')
  end

  def update(title: nil, memo: nil, list: nil, position: nil)
    fill_title(title) if title
    fill_memo(memo) if memo
    select_list(list) if list
    select_position(position) if position
    submit('Save')
  end

  # --- primitives ---

  def fill_title(title)
    # TODO: [data-testid="input-card-title"]
    fill_in 'Title', with: title
  end

  def fill_memo(text)
    # TODO: [data-testid="input-card-memo"]
    # NOTE: 新規作成と編集ではラベルが異なるためプレースホルダーを指定している
    fill_in placeholder: 'Write a comment...', with: text
  end

  def select_list(name)
    # TODO: [data-testid="select-card-list"]
    select name, from: 'List'
  end

  def select_position(position)
    # TODO: [data-testid="select-card-position"]
    select position, from: 'Position'
  end

  def submit(button_text)
    click_button(button_text)
  end
end
