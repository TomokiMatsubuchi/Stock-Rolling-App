class ExpendableItemsController < ApplicationController
  include ExpendableItemsHelper
  before_action :authenticate_user!
  before_action :correct_user_expendable_item, only: %i[show edit update destroy]

  def index
    @expendable_items = current_user.expendable_items.order('deadline_on ASC').page(params[:page])
  end

  def new
    @expendable_item = ExpendableItem.new
  end

  def create
    @expendable_item = ExpendableItem.new(expendable_item_params)
    @expendable_item.user_id = current_user.id
    @expendable_item.reference_date = Date.current
    deadline
    if @expendable_item.save
      flash[:notice] = '消耗品の新規登録が完了しました!'
      redirect_to expendable_items_path
    else
      render :new
    end
  end

  def show
    @expendable_item = ExpendableItem.find(params[:id])
    if params[:set_reference_day]
      reset_deadline
      flash[:notice] = '本日を消費開始日に再設定しました!'
      redirect_to expendable_items_path
    end
  end

  def edit
    @expendable_item = ExpendableItem.find(params[:id])
  end

  def update
    @expendable_item = ExpendableItem.find(params[:id])
    deadline
    if @expendable_item.update(expendable_item_params)
      flash[:notice] = '消耗品情報を更新しました!'
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
