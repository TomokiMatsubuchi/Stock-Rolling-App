require 'line/bot'
require "selenium-webdriver"

class LinebotController < ApplicationController
  include LinebotHelper
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      user_id = event['source']['userId']
      user = User.where(uid: user_id)[0]
      if event.message['text'].include?("お買い物リスト")
        message = shopping_list(send_limit_item(user))
      elsif event.message['text'].include?("自動購入機能テスト")
        message = test_selenium(user)
        binding.pry
      end

      case event
      # メッセージが送信された場合
      when Line::Bot::Event::Message
        case event.type
        # メッセージが送られて来た場合
        when Line::Bot::Event::MessageType::Text
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end

  private
  def test_selenium(user)
    @wait_time = 10 
    @timeout = 180

    Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
    Selenium::WebDriver.logger.level = :warn

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1280x800')
    ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
    options.add_argument("--user-agent=#{ua}")

    @driver = Selenium::WebDriver.for :remote, url: 'http://chrome:4444/wd/hub', capabilities: [:chrome], options: options

    @driver.manage.timeouts.implicit_wait = @timeout
    wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)

    if amazon_login(user) != false
      sleep 5
      @driver.get('https://www.amazon.co.jp/gp/flex/sign-out.html?path=%2Fgp%2Fyourstore%2Fhome&signIn=1&useRedirectOnSuccess=1&action=sign-out&ref_=nav_AccountFlyout_signout') #logout
      sleep 5
      @driver.quit
      response = {
        type: 'text',
        text: "正常にテストが完了しました。"
      }
    else
      sleep 5
      @driver.get('https://www.amazon.co.jp/gp/flex/sign-out.html?path=%2Fgp%2Fyourstore%2Fhome&signIn=1&useRedirectOnSuccess=1&action=sign-out&ref_=nav_AccountFlyout_signout') #logout
      sleep 5
      @driver.quit
      response = {
        wrap: true,
        type: 'text',
        text: "何らかの障害によりテストが失敗しました。\n初回利用の場合はamazonより届く\nメールからブラウザを信用する設定をしてください。"
      }
    end
  end

  def amazon_login(user)
    if user.ec_login_id.present? && user.ec_login_password.present?
      begin
        @driver.get('https://www.amazon.co.jp/gp/help/customer/display.html?nodeId=201909000')
        sleep 5
        @driver.get('https://www.amazon.co.jp/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2Fref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=jpflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&')
        sleep 5
        if user.ec_login_id.present? && user.ec_login_password.present?
          login_email = @driver.find_element(:name, 'email').send_keys(user.ec_login_id)
          sleep 5
          if @driver.find_elements(:id, 'continue').size >= 1
            sleep 5
            @driver.find_element(:id, 'continue').click
          end
          sleep 5
          login_password = @driver.find_element(:name, 'password').send_keys(user.ec_login_password)
          sleep 5
          login_submit = @driver.find_element(:id, 'signInSubmit').click
          sleep 5
          login?(user)
        end
      rescue
        false
      end
    else
      false
    end
  end

  def login?(user)
    begin
      @driver.get('https://www.amazon.co.jp/')
      sleep 5
      if @driver.find_element(:id, 'nav-link-accountList-nav-line-1').text.include? "ログイン"
        sleep 5
        message = {
          type: 'text',
          text: "ecサイトのログインIDまたはパスワードに不備があるため自動購入できませんでした。ヒント:初回使用の際はプログラムがログインすることをAmazonから届いたメールより承認する必要があります。"
        }
        line_message(user, message)
        false  
      end
    rescue
      true
    end
  end
end
