# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication base', type: :system do
  let(:user) { create(:user, password: 'password') }

  it 'ログインしてトップページに遷移すること' do
    LoginPage.new.visit!.login(name: user.name, password: 'password')
    # ここでは遷移先のパスのみ確認（表示コンテンツは別途確認）
    expect(page).to have_current_path(root_path)
  end
end
