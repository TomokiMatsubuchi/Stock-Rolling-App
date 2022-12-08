require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default

  def perform
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    
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
        response = client.push_message(user.uid, message)
        p responce
        logger.info responce
      end
    end
    logger.info "Lineは送信されませんでした。"
  end
end
