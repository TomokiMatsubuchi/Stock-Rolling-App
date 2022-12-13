require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'Login処理' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:line]
    end
    context 'LINEログインボタンを押した場合' do
      it 'ログインができる' do
        visit new_user_session_path
        click_on  'line_login'
        expect(page).to have_content 'お買い物リスト'
      end
    end
  end
end
