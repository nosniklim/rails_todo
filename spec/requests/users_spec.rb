require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  before { sign_in user } # Devise のヘルパーでログイン

  describe 'GET /user/:id/edit' do
    context 'ログインユーザーが自分の編集ページにアクセスする場合' do
      it '200 OK を返す' do
        get edit_user_path(user.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインユーザーが他のユーザーの編集ページにアクセスする場合' do
      let(:other_user) { create(:user) }

      it '自分の編集ページにリダイレクトされる' do
        get edit_user_path(other_user.id)
        expect(response).to redirect_to(edit_user_path(user.id))
      end
    end
  end

  describe 'PATCH /user/:id' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { user: { name: 'Updated Name' } } }

      it 'ユーザー情報を更新し、ルートにリダイレクトする' do
        patch user_path(user.id), params: valid_params
        expect(user.reload.name).to eq('Updated Name')
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { user: { name: '' } } }

      it 'ユーザー情報を更新せず、edit テンプレートを再表示する' do
        patch user_path(user.id), params: invalid_params
        expect(user.reload.name).not_to eq('')
        expect(response).to render_template(:edit)
      end
    end
  end
end
