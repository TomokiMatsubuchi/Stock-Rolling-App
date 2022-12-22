# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :require_no_authentication, only: :new
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

    #DELETE /resource/sign_out
  def destroy
    super
    flash[:notice] = 'ログアウトしました。'
  end

private

def require_no_authentication
  assert_is_devise_resource!
  return unless is_navigational_format?
  no_input = devise_mapping.no_input_strategies

  authenticated = if no_input.present?
    args = no_input.dup.push scope: resource_name
    warden.authenticate?(*args)
  else
    warden.authenticated?(resource_name)
  end

  if authenticated && resource = warden.user(resource_name)
    set_flash_message(:alert, 'already_authenticated', scope: 'devise.failure')
    redirect_to expendable_items_path
  end
end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
