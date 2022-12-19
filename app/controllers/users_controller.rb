class UsersController < ApplicationController
  before_action :correct_user, only: [:show] 

  def show
    @user = User.find(params[:id])
  end

  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to expendable_items_path, flash: {warn: "アクセス権限がありません"} unless current_user?(@user)
  end
end
