require 'rails_helper'

RSpec.describe 'Top', type: :request do
  let(:user) { create(:user) }

  describe 'GET /' do
    context 'ログイン時' do
      before { sign_in user } # Devise のテストヘルパーでログイン

      it '200 OK を返す' do
        get root_path
        expect(response).to have_http_status(:ok)
      end

      it 'ヘッダーコンテンツが表示される' do
        get root_path
        expect(response.body).to include(user.name)
        expect(response.body).to include('Todolist')
        expect(response.body).to include('New List')
        expect(response.body).to include('Sign out')
      end
    end

    context '未ログイン時' do
      it 'ログインページへリダイレクトする' do
        get root_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
