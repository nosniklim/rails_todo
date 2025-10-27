# frozen_string_literal: true

require 'capybara/rspec'

class TopPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  # トップページに戻る
  def visit!
    visit root_path
    self
  end

  # 指定タイトルのリストの存在チェック
  def has_list?(title)
    # TODO: [data-testid="list"]
    within('.list') do
      # TODO: [data-testid="list-header-title"]
      return page.has_selector?('.list_header_title', text: title)
    end
  end

  # 指定リストにカードを追加（新規作成クリックしたら、入力はCardFormPageへ委譲）
  def add_card_to(list_title, title:, memo: nil)
    within_list(list_title) do
      # TODO: [data-testid="link-add-card"]
      find('.addCard_link', match: :first).click
    end
    CardFormPage.new.create(title: title, memo: memo)
  end

  # カード詳細へ遷移
  def open_card(title)
    # TODO: [data-testid="link-card-detail"]
    find('.cardDetail_link', text: title).click
    CardShowPage.new
  end

  def within_list(list_title, &block)
    list = find('.list', text: list_title, match: :first)
    within(list, &block)
  end
end
