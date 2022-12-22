require "selenium-webdriver"
require 'line/bot'

class BuyAmazonJob < ApplicationJob
  queue_as :default

  def perform(*args)

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

    users = User.all
    users.each do |user|
      limit_seven_days = Date.today..Time.now.end_of_day + (7.days)
      limit_items =  ExpendableItem.where(user_id: user.id).where(deadline_on: limit_seven_days)
      if limit_items != []
        if amazon_login(user) != false
          limit_items.each do |item|
            if item.auto_buy = "する"
              begin
                @driver.get(item.product_url)
                buy = @driver.find_element(:id, 'buy-now-button')
                buy.submit
                sleep 5
                buy = @driver.find_element(:name, 'proceedToRetailCheckout')
                buy.submit
                sleep 5
                buy = @driver.find_element(:name, 'placeYourOrder1')
                buy.click
                sleep 5
                if @driver.title.include? "ありがとうございました"
                  message = {
                    type: 'text',
                    text: "#{item.name}の購入が完了しました。ecサイトにて注文履歴をご確認ください。"
                  }
                  line_message(user, message)
                  send_date = @driver.find_element(:id, 'delivery-promise-orderGroupID0#itemGroupID0').find_element(:class, 'break-word').text.split[0]
                  @driver.find_element(:id, 'nav-link-accountList-nav-line-1').text
                  amount_of_day = item.amount_of_product /  item.amount_to_use / item.frequency_of_use
                  deadline_on = reference_day(send_date).since(amount_of_day.days)
                  item.update(deadline_on: deadline_on, reference_date: reference_day(send_date))
                else
                  message = {
                    type: 'text',
                    text: "なんらかの不具合により自動購入できませんでした。"
                  }
                  line_message(user, message)
                end
              rescue
                logger.info "Amazon購入にて障害発生"
              end
            end
          end
        end
        sleep 5
        logout = @driver.get('https://www.amazon.co.jp/gp/flex/sign-out.html?path=%2Fgp%2Fyourstore%2Fhome&signIn=1&useRedirectOnSuccess=1&action=sign-out&ref_=nav_AccountFlyout_signout')
        sleep 5
      end
    end
    @driver.quit
  end
  
  private

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
        logger.info "Amazonログインにて障害発生"
        false
      end
    else
      false
    end
  end

  def line_message(user, message)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    if user.line_alert == true
      response = client.push_message(user.uid, message)
    end
  end

  def reference_day(send_date)
    year = Date.current.year
    month_day = send_date.scan(/\d+/)
    reference_day = "#{year}-#{month_day.join('-')}".to_date
    if reference_day < Date.current
      reference_day.years_since(1)
    else
      reference_day
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