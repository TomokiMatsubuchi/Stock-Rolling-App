require 'rails_helper'

RSpec.describe ExpendableItem, type: :model do
  user = User.find_by(email: "sample_taro@example.com") || FactoryBot.create(:user_1)
  describe "バリデーションのテスト" do
    context "消耗品情報が全てある場合" do
      it "消耗品情報が登録できる" do
        item = FactoryBot.create(:item_1, user: user)
        expect(item).to be_valid
      end
    end

    context "内容量・使用量・使用頻度が数字ではない場合" do
      it "消耗品情報が登録できない" do
        item = ExpendableItem.create(name: "taro", amount_of_product: "aradsf", amount_to_use: "asdf", frequency_of_use: "fasdf", deadline_on: Date.current.since(33.days), image: nil, product_url: "http://example.com", auto_buy: "しない", reference_date: Date.current, user: user)
        expect(item).to be_invalid
      end
    end

    context "URLが「http://~」ではない場合" do
      it "消耗品情報が登録できない" do
        item = ExpendableItem.create(name: "taro", amount_of_product: 500, amount_to_use: 5, frequency_of_use: 3, deadline_on: Date.current.since(33.days), image: nil, product_url: "example.com", auto_buy: "しない", reference_date: Date.current, user: user)
        expect(item).to be_invalid
      end
    end
  end
end
