class Admin::UsersController < ApplicationController
  before_action :admin_required, only: [:index, :destroy]

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy 
      flash[:notice] = '#{@user.name}を削除しました。'
      redirect_to admin_users_path
    else
      flash[:error] = '管理者が0人になってしまうため削除できません。'
      redirect_to admin_users_path
    end
  end

  private

  def admin_required
    redirect_to expendable_items_path, flash: {warn: "管理者以外はアクセスできません"} unless user_admin?
  end
end
