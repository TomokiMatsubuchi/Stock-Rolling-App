require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default

  def perform
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }



    message = {
          type: 'text',
          text: "テストです。"
          }
          response = client.push_message(User.find(1).uid, message)


    #near_limit_items = ExpendableItem.where(deadline_on: Date.today..Time.now.end_of_day + (2.days))
    #near_limit_items.each do |item|
    #  @user = item.user
    #  limit_message = {
    #    type: 'text',
    #    text: "#{item.name}の消費完了が近づいています。"
    #    }
    #    limit_response = client.push_message(@user.uid, limit_message)
    #end
#
    #other_limit_items = ExpendableItem.where(deadline_on: Date.today..Time.now.end_of_day + (5.days), user_id: @user).where.not(deadline_on: Date.today..Time.now.end_of_day + (2.days))
    #  other_limit_items.each do |oth|
    #    oth_message = {
    #      type: 'text',
    #      text: "他にも#{oth.name}の消費完了が近いです。"
    #    }
    #    oth_response = client.push_message(@user.uid, oth_message)
    #  end
  end
end
