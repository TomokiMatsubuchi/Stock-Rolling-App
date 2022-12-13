require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default

  def perform(*args)
    limit_seven_days = Date.today..Time.now.end_of_day + (7.days)
    users = User.all
    users.each do |user|
      if user.line_alert == true
        limit_items =  ExpendableItem.where(user_id: user.id).where(deadline_on: limit_seven_days)
        names = limit_items.map {|item| item.name } 
        message = {
              type: 'text',
              text: "1週間以内に#{names.join(',')}が無くなります。早めの買い足しをオススメします。"
            }
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
