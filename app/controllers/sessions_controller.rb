class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token

  swagger_controller :sessions, "User's Session Management"

  swagger_api :create do
    summary 'Sign in a activated user to start the session'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[password]', :string, :required, 'Password'
    response :ok
    response :unauthorised
    response :forbidden
  end

  def create
    user = User.where(email: params[:user][:email].downcase).first
    if user && user.authenticate(params[:user][:password])
      if user.active?
        api_key = login user
        render json: { api_key: api_key }
      else
        render json: { error: _('errors.not_activated') }, status: :forbidden
      end
    else
      render json: { error: _('errors.authentication_failure') }, status: 401
    end
  end

  swagger_api :destroy do
    summary 'Sign out active session of the user'
    response :ok
    response :forbidden
  end

  def destroy
    logout if logged_in?
    render nothing: true, status: :ok
  end
end