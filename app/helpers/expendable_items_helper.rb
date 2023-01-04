module ExpendableItemsHelper
  def reset_deadline
    reference_date = Date.current
    amount_of_day = @expendable_item.amount_of_product /  @expendable_item.amount_to_use / @expendable_item.frequency_of_use
    deadline_on = reference_date.since(amount_of_day.days)
    @expendable_item.update(deadline_on: deadline_on, reference_date: reference_date)
  end

  def deadline
    amount_of_product = params[:expendable_item][:amount_of_product].to_i
    amount_to_use = params[:expendable_item][:amount_to_use].to_i
    frequency_of_use = params[:expendable_item][:frequency_of_use].to_i
    if amount_of_product > 0 && amount_to_use > 0 && frequency_of_use > 0
      amount_of_day = amount_of_product /  amount_to_use / frequency_of_use
      @expendable_item.deadline_on = @expendable_item.reference_date.since(amount_of_day.days)
    end
  end

  def correct_user_expendable_item
    @expendable_item = ExpendableItem.find(params[:id])
    user = User.find(@expendable_item.user_id)
    return if user_admin?
    redirect_to expendable_items_path, flash: {warn: "アクセス権限がありません"} unless current_user?(user)
  end
end
