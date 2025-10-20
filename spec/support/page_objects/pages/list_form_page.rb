# frozen_string_literal: true

class ListFormPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_new!
    visit new_list_path
    self
  end

  def create(title:)  
    fill_title(title)
    submit('Create')
  end

  def update(title:, position:)
    fill_title(title)
    select_position(position)
    submit('Save')
  end

  # --- primitives ---

  def fill_title(title)
    # TODO: [data-testid="input-list-title"]
    fill_in 'Title', with: title
  end

  def select_position(position)
    # TODO: [data-testid="select-llist-position"]
    find('#list_position').select(position)
  end

  def submit(button_text)
    # TODO: [data-testid="btn-submit"]
    click_button(button_text)
  end
end
