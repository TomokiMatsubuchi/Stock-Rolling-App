require "selenium-webdriver"


class BuyAmazonJob < ApplicationJob
  queue_as :default

  def perform(*args)

    @wait_time = 10 
    @timeout = 180

    Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
    Selenium::WebDriver.logger.level = :warn

    driver = Selenium::WebDriver.for :remote, url: 'http://chrome:4444/wd/hub', capabilities: [:chrome]

    driver.manage.timeouts.implicit_wait = @timeout
    wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)

    driver.get('https://www.yahoo.co.jp/')

    sleep 2

    driver.quit
  end
end
