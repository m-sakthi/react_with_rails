class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session.
  # protect_from_forgery with: :exception
  # protect_from_forgery unless: -> { request.format.json? }
  protect_from_forgery with: :null_session
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from CanCan::AccessDenied, with: :forbidden_access
  rescue_from Sblog::Exception::InvalidParameter, with: :invalid_parameter

  # before_action :authenticate_user!

  def authenticate_user!
    unauthorized_access if !logged_in?
  end

  private
    def unauthorized_access
      render json: { error: _('errors.unauthorised_access') }, status: 401
    end

    def record_not_found
      render json: { error: _('errors.not_found') }, :status => 404
    end

    def forbidden_access
      render json: { error: _('errors.forbidden') }, status: :forbidden
    end

    def invalid_parameter(exception)
      render json: { error: {message: exception.message} }, status: :bad_request
    end
end
