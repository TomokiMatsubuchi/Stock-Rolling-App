# テスト用にモックを使うための設定
# '/auth/provider'へのリクエストが、即座に'/auth/provider/callback'にリダイレクトされる
OmniAuth.config.test_mode = true

# Line用のモック
# '/auth/provider/callback'にリダイレクトされた時に渡されるデータを生成
OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
  provider: 'line', 
  uid: '12345', 
  info: { email: 'test1@example.com', name: 'test_user' },
  credentials: { token: '1234qwer' }
)