require "selenium-webdriver"
require 'line/bot'

class BuyAmazonJob < ApplicationJob
  queue_as :default

  def perform(*args)

    @wait_time = 10 
    @timeout = 180

    Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
    Selenium::WebDriver.logger.level = :warn

    @driver = Selenium::WebDriver.for :remote, url: 'http://chrome:4444/wd/hub', capabilities: [:chrome]

    @driver.manage.timeouts.implicit_wait = @timeout
    wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)

    users = User.all
    users.each do |user|
      limit_seven_days = Date.today..Time.now.end_of_day + (7.days)
      limit_items =  ExpendableItem.where(user_id: user.id).where(deadline_on: limit_seven_days)
      if amazon_login(user) != false
        limit_items.each do |item|
          if item.auto_buy = "する"
            @driver.get(item.product_url)
            buy = @driver.find_element(:id, 'buy-now-button')
            buy.submit
            sleep 5
            buy = @driver.find_element(:name, 'proceedToRetailCheckout')
            buy.submit
            sleep 5
            buy = @driver.find_element(:name, 'placeYourOrder1')
            buy.click
            @driver.title
            if @driver.title == "Amazonより、ありがとうございました"
              message = {
                type: 'text',
                text: "#{item.name}の購入が完了しました。ecサイトにて注文履歴をご確認ください。"
              }
              line_message(user, message)
              #reference_date = @driver.find_element(:id, 'delivery-promise-orderGroupID0#itemGroupID0').find_element(:class, 'break-word').text.split[0]
              #amount_of_day = item.amount_of_product /  item.amount_to_use / item.frequency_of_use
              #deadline_on = reference_date.since(amount_of_day.days)
              #item.update(deadline_on: deadline_on, reference_date: reference_date)
              item.update(auto_buy: "しない")
            else
              message = {
                type: 'text',
                text: "登録されている商品URLに不備があるため自動購入できませんでした。"
              }
              line_message(user, message)
            end
          end
        end
      end
      #logout処理
      @driver.get('https://www.amazon.co.jp/gp/flex/sign-out.html?path=%2Fgp%2Fyourstore%2Fhome&signIn=1&useRedirectOnSuccess=1&action=sign-out&ref_=nav_AccountFlyout_signout')
      sleep 5
    end
    @driver.quit
  end
  
  private

  def amazon_login(user)
    @driver.get('https://www.amazon.co.jp/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2Fref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=jpflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&')
    if user.ec_login_id.present? && user.ec_login_password.present?
      login = @driver.find_element(:id, 'ap_email')
      login.send_keys(user.ec_login_id)
      login.submit
      sleep 5
      login = @driver.find_element(:id, 'ap_password')
      login.send_keys(user.ec_login_password)
      login.submit
      unless @driver.title == "Amazon | 本, ファッション, 家電から食品まで | アマゾン"
        message = {
          type: 'text',
          text: "ecサイトのログインIDまたはパスワードに不備があるため自動購入できませんでした。"
        }
        line_message(user, message)
        return false
      end
    end
  end

  def line_message(user, message)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    response = client.push_message(user.uid, message)
  end
end
