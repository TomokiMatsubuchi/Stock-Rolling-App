class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :logout_required

  def logout_required
    if user_signed_in? 
      if request.fullpath == "/sessions/new"
        flash[:warning] = "ログアウトしてください"
        redirect_to expendable_items_path
      end
    end
  end
end
