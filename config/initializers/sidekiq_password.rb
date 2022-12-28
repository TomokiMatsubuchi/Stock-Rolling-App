require 'sidekiq'
require 'sidekiq/web'

#Basic認証時のユーザー名とパスワードを設定する
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_USER'], ENV['SIDEKIQ_PASSWORD']] #環境変数にて設定
end