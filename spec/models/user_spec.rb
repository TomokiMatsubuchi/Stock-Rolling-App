require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    context "ユーザ情報が全てある場合" do
      it "ユーザが登録できる" do
        user = User.find_by(email: "sample_taro@example.com") || FactoryBot.create(:user_1)
        expect(user).to be_valid
      end
    end
  end
end
