# frozen_string_literal: true

require 'capybara/rspec'

class TopPage
  include Capybara::DSL

  # トップページに戻る
  def visit!
    visit root_path
    self
  end

  # 指定タイトルのリストの存在チェック
  def has_list?(title)
    within('.list') do
      return page.has_selector?('.list_header_title', text: title)
    end
  end

  # 指定リストにカードを追加（新規作成クリックしたら、入力はCardFormPageへ委譲）
  def add_card_to(list_title, title:, memo: nil)
    within_list(list_title) do
      find('.addCard', match: :first).click
    end
    CardFormPage.new.create(title: title, memo: memo)
  end

  # カード詳細へ遷移
  def open_card(title)
    find('.cardDetail_link', text: title).click
    CardShowPage.new
  end

  private

  def within_list(list_title, &block)
    list = find(:xpath,
                "//div[contains(@class, 'listWrapper')][.//div[contains(@class, 'list_header_title') and normalize-space(text())='#{list_title}']]")
    within(list, &block)
  end
end
