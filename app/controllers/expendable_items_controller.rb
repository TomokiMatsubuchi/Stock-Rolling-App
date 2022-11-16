class ExpendableItemsController < ApplicationController
  def index
    @expendable_items = ExpendableItem.all
  end

  def new
    @expendable_item = ExpendableItem.new
  end

  def create
    @expendable_item = ExpendableItem.new(expendable_item_params)
    #@expendable_item.user_id = current_user.id
    if @expendable_item.save
      amount_of_day = @expendable_item.amount_of_product /  @expendable_item.amount_to_use /  @expendable_item.frequency_of_use
      deadline = @expendable_item.created_at.since(amount_of_day.days)
      @expendable_item.update(deadline_on: deadline)
      flash[:notice] = '消耗品の新規登録が完了しました!'
      redirect_to expendable_items_path
    else
      render :new
    end
  end

  def show
    @expendable_item = ExpendableItem.find(params[:id])
  end

  def edit
    @expendable_item = ExpendableItem.find(params[:id])
  end

  def update
    @expendable_item = ExpendableItem.find(params[:id])
    if @expendable_item.update(expendable_item_params)
      amount_of_day = @expendable_item.amount_of_product /  @expendable_item.amount_to_use /  @expendable_item.frequency_of_use
      deadline = @expendable_item.created_at.since(amount_of_day.days)
      @expendable_item.update(deadline_on: deadline)
      flash[:notiece] = '消耗品情報を更新しました!'
      redirect_to expendable_items_path
    else
      render :edit
    end
  end

  def destroy
    @expendable_item = ExpendableItem.find(params[:id])
    @expendable_item.destroy
    flash[:notice] = '消耗品情報を削除しました!'
    redirect_to expendable_items_path
  end

  private

  def expendable_item_params
    params.require(:expendable_item).permit(:name, :amount_of_product, :deadline_on, :image, :amount_to_use, :frequency_of_use, :product_url, :auto_buy)
  end
end
