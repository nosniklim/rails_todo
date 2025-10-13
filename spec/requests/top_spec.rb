require "rails_helper"

RSpec.describe "Top", type: :request do
  let(:user) { create(:user) }

  describe "GET /" do
    context "ログイン時" do
      before { sign_in user } # Devise のテストヘルパーでログイン

      subject(:request!) { get root_path; response }

      it "200 OK を返す" do
        expect(request!).to have_http_status(:ok)
      end

      it "ヘッダーコンテンツが表示される" do
        resp = request!
        expect(resp.body).to include(user.name)
        expect(resp.body).to include("Todolist")
        expect(resp.body).to include("New List")
        expect(resp.body).to include("Sign out")
      end
    end

    context "未ログイン時" do
      subject(:request!) { get root_path; response }

      it "ログインページへリダイレクトする" do
        expect(request!).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end