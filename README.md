## README

## Stock Roller
![facebook_cover_photo_2](https://user-images.githubusercontent.com/109142010/206126785-c8e09255-e155-4ba8-9e12-70fc1bc6de01.png)

## 製品概要 / Overview
日常生活の中で日々使っていくシャンプーや石鹸、洗剤などの日用品が気づいたときに空っぽになっていたという経験はありませんか?<br>
また、買い物は意外と時間がかかりますし、必要なものを買いに行くためだけにわざわざ外出するとなるとやる気も起きません。<br>
Stock Rollerはこの問題を解決するための2つの機能を提供します。<br>
①使用している日用品をあらかじめ登録しておくことで無くなる1週間前からLINEでリマインドを送信します。<br>
②時間を有効活用したい方向けにECサイトの情報を登録しておくと自動で購入してくれます。<br>
上記2点の機能により、あなたの買い物に煩わされる時間を減らし生活を豊かにするお手伝いをします。

## 開発言語 / Language
- OS: Linux
- Ruby 3.0.1
- Ruby on Rails 6.0.6
- Javascript(JQuery)

## インフラ / Inrastructure
- AWS (EC2)
- Docker
- Docker-compose

## インフラ図 / Infrastructure Image
![インフラ図 drawio](https://user-images.githubusercontent.com/109142010/206839880-81f7f727-6515-4ec0-bd1d-3c7c4074d7c5.png)
- [AWS EC2内のディレクトリツリーはこちら](https://github.com/TomokiMatsubuchi/Stock-Rolling-App/issues/62#issue-1488194590)



## 機能・使用Gem / Functions・Gem
- LINE ログイン
  - devise
  - omniauth-line
  - omniauth-rails_csrf_protection
- LINE BOT 連携
  - line-bot-api
- 非同期処理
  - sidekiq
  - sidekiq-scheduler
- API(Amazon or 楽天 or yahoo)
  - 実装検討中
- seleniumによるwebスクレイピングを使った自動購入機能
  - selenium-webdriver
- Docker導入
  - nokogiri
  - mini_portile2
- 国際化
  -rails-i18n
- ページネーション
  - kaminari
  
## 実行手順
```
$ git clone git@github.com:TomokiMatsubuchi/Stock-Rolling-App.git
$ cd Stock-Rolling-App
$ bundle install && bundle update
$ docker-compose build --no-cache
$ docker-compose up
```

## カタログ設計
https://docs.google.com/spreadsheets/d/1Dplg45OdAWnwA3Q4DicvMR_th0TeC_sPTAxgIeVe1Z0/edit?usp=sharing

## テーブル定義書
https://docs.google.com/spreadsheets/d/1Dplg45OdAWnwA3Q4DicvMR_th0TeC_sPTAxgIeVe1Z0/edit?usp=sharing

## ワイヤーフレーム
https://www.figma.com/file/cSqLa46wTlUkerUtXOBA0f/Untitled?node-id=0%3A1&t=UoaGCX4zWbPLfwvl-1

## ER図
![スクリーンショット 2022-11-30 10 03 36](https://user-images.githubusercontent.com/109142010/204688148-86f9b565-a37b-44fb-98e9-f65e1d87af4f.png)




## 画面遷移図
![スクリーンショット 2022-11-11 17 50 02](https://user-images.githubusercontent.com/109142010/201307960-78040376-f52a-4024-bc5b-c5608ac9ab2d.png)

