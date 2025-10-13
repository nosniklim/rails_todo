require 'rails_helper'

RSpec.describe 'Cards', type: :request do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let!(:card) { create(:card, list: list) }

  before { sign_in user } # Devise のヘルパーでログイン

  describe 'GET /list/:list_id/card/:id' do
    it '200 OK を返す' do
      get list_card_path(list_id: list.id, id: card.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /list/:list_id/card/:id/edit' do
    it '200 OK を返す' do
      get edit_list_card_path(list_id: list.id, id: card.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /list/:list_id/card/:id' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { card: { title: 'Updated Title', memo: 'Updated Memo' } } }

      it 'カードを更新し、ルートにリダイレクトする' do
        patch list_card_path(list_id: list.id, id: card.id), params: valid_params
        expect(card.reload.title).to eq('Updated Title')
        expect(card.reload.memo).to eq('Updated Memo')
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { card: { title: '' } } }

      it 'カードを更新せず、edit テンプレートを再表示する' do
        patch list_card_path(list_id: list.id, id: card.id), params: invalid_params
        expect(card.reload.title).not_to eq('')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET /list/:list_id/card/new' do
    it '200 OK を返す' do
      get new_list_card_path(list_id: list.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /list/:list_id/card' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { card: { title: 'New Card', memo: 'New Memo', list_id: list.id } } }

      it 'カードを作成し、ルートにリダイレクトする' do
        expect {
          post list_card_index_path(list_id: list.id), params: valid_params
        }.to change(Card, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { card: { title: '', list_id: list.id } } }

      it 'カードを作成せず、new テンプレートを再表示する' do
        expect {
          post list_card_index_path(list_id: list.id), params: invalid_params
        }.not_to change(Card, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE /list/:list_id/card/:id' do
    it 'カードを削除し、ルートにリダイレクトする' do
      expect {
        delete list_card_path(list_id: list.id, id: card.id)
      }.to change(Card, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end
