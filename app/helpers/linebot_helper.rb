module LinebotHelper
  private
  
  def send_limit_item(user)
    limit_seven_days = Date.today..Time.now.end_of_day + (7.days)
    limit_items =  ExpendableItem.where(user_id: user.id).where(deadline_on: limit_seven_days)
    if limit_items != []
      names = limit_items.map {|item| item.name } 
      response = "1週間以内に以下の消耗品が無くなります。\n早めの買い足しをオススメします。\n\n#{names.join("\n")}"
    else
      response = "1週間以内に無くなる消耗品はありません。"
    end
  end

  def shopping_list(response)
    {
      type: 'flex',
      altText: 'お買い物リスト',
      contents: {
        type: 'bubble',
        header:{
          type: 'box',
          layout: 'horizontal',
          contents:[
            {
              type: 'text',
              text: 'お買い物リスト',
              wrap: true,
              size: 'md',
            }
          ]
        },
        body: {
          type: 'box',
          layout: 'horizontal',
          contents: [
            {
              type: 'text',
              text: response,
              wrap: true,
              size: 'sm',
            }
          ]
        }
      }
    }
  end
end
