require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default
  include LinebotHelper

  def perform(*args)
    users = User.all
    users.each do |user|
      if user.line_alert == true
        message = shopping_list(send_limit_item(user))
        response = line_client.push_message(user.uid, message)
        logger.info "PushLineSuccess"
      end
    end
  end

  private

  def line_client
    Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
