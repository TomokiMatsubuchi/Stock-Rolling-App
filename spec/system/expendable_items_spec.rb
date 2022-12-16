require 'rails_helper'

RSpec.describe "消耗品情報管理機能", type: :system do
  
  describe '消耗品情報登録' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:line]
      visit new_user_session_path
      click_on  'line_login'
    end
    context '消耗品情報を登録した場合' do
      it '登録した消耗品が表示される' do
        click_on '新規消耗品の登録'
        fill_in 'expendable_item_name', with: 'シャンプー'
        fill_in 'expendable_item_amount_of_product', with: '500'
        fill_in 'expendable_item_amount_to_use', with: '25'
        fill_in 'expendable_item_frequency_of_use', with: '1'
        click_on 'commit'
        expect(page).to have_content 'シャンプー'
      end
    end

    context '消耗品情報を更新する場合' do
      it '消耗品が更新されて表示される' do
        page.all('.show-item')[0].click
        click_on '商品情報の編集'
        fill_in 'expendable_item_name', with: 'リンス'
        click_on 'commit'
        expect(page).to have_content 'リンス'
      end
    end

    context '消費開始日の更新をする場合' do
      it '一覧にて本日を消費開始日に再設定しましたと表示が出る' do
        page.all('.show-item')[0].click
        click_link '本日を消費開始日に再設定する'
        expect(page).to have_content '本日を消費開始日に再設定しました!'
      end
    end

    context '消耗品情報を削除する場合' do
      it '消耗品情報を削除できる' do
        page.all('.destroy-item')[0].click
        expect(page).to have_content '消耗品情報を削除しました!'
      end
    end
  end

  describe 'アクセス制限に関するテスト' do
    
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:line]
      visit new_user_session_path
      click_on  'line_login'
    end
    context '他者の消耗品情報にアクセスしようとした場合' do
      it 'アクセスに失敗する' do
        user = User.find_by(email: "sample_taro@example.com") || FactoryBot.create(:user_1)
        other_user_item = FactoryBot.create(:item_1, user: user)
        visit expendable_item_path(other_user_item.id)
        expect(page).to have_content 'アクセス権限がありません'
      end
    end
  end
end
