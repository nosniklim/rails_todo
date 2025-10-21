# frozen_string_literal: true

require 'capybara/rspec'

class CardShowPage
  include Capybara::DSL

  def have_title?(text)
    # TODO: [data-testid="card-title"]
    page.has_selector?('.cardContents_title', text: text)
  end

  def have_memo?(text)
    # TODO: [data-testid="card-memo"]
    page.has_selector?('.cardContents_memo', text: text)
  end

  def have_list?(name)
    # TODO: [data-testid="card-list"]
    page.has_selector?('.cardContents_list', text: name)
  end

  def have_position?(position)
    # TODO: [data-testid="card-position"]
    page.has_selector?('.cardContents_position', text: position)
  end

  def click_edit
    # TODO: [data-testid="link-card-edit"]
    find('.cardContents_btnArea .edit_btn').click
    CardFormPage.new
  end

  def remove!
    accept_confirm do
      # TODO: [data-testid="link-card-remove"]
      find('.cardContents_btnArea .delete_btn').click
    end
  end
end
