class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :load_user, except: [:create, :index, :profile]
  load_and_authorize_resource except: [:create, :index, :profile, :details]
  swagger_controller :users, "User Management"

  swagger_api :index do
    summary 'Lists all User'
    param_list :query, :status, :string, :optional, 'Status', User::Status::ALL
    param :query, :limit, :integer, :optional, 'Number of users per page'
    param :query, :page_number, :integer, :optional, 'Page Number'
    response :ok
    response :unauthorized
    response :forbidden
  end

  def index
    if params[:status].present?
      @users = User.send(params[:status].to_sym)
    else
      @users = User.all
    end
    @users = @users.page(params[:page_number]).per(params[:limit])
  end
  
  def new
  end

  swagger_api :create do
    summary 'Create a new user'
    param :form, :'user[email]', :string, :required, "Email"
    param :form, :'user[password]', :string, :required, 'Password'
    param :form, :'user[password_confirmation]', :string, :required, 'Password Confirmation'
    param :form, :'user[user_name]', :string, :optional, "User name"
    param :form, :'user[first_name]', :string, :optional, "First name"
    param :form, :'user[last_name]', :string, :optional, "Last name"
    param :form, :'user[profile_pic]', :string, :optional, "Profile Picture"
    response :created
    response :bad_request
    response :forbidden
    response :not_acceptable
    response :unauthorized
  end

  def create
    @user = User.create(create_params)
    if @user.errors.present?
      render 'shared/model_errors', locals: { object: @user }, status: :bad_request
    else
      # @user.send_activation_email
      render 'show', status: :created
    end
  end

  swagger_api :profile do
    summary 'Current User''s Profile'
    response :ok
  end

  def profile
    @user = current_user
    render 'show', status: :ok
  end

  swagger_api :update do
    summary 'Update a user'
    param :path, :id, :integer, :required, 'User ID'
    param :form, :'user[email]', :string, :optional, "Email"
    param :form, :'user[user_name]', :string, :optional, "User name"
    param :form, :'user[first_name]', :string, :optional, "First name"
    param :form, :'user[last_name]', :string, :optional, "Last name"
    param :form, :'user[profile_pic]', :string, :optional, "Profile Picture"
    response :created
    response :bad_request
    response :forbidden
    response :not_acceptable
    response :unauthorized
  end

  def update
    @user.update(update_params)
    if @user.errors.present?
      render 'shared/model_errors', locals: { object: @user }, status: :bad_request
    else
      render 'show', status: :created
    end
  end

  def edit
  end

  [:block, :activate, :destroy].each do |action|
    swagger_api action do
      summary "#{action} a user"
      param :path, :id, :integer, :required, 'User ID'
      response :ok
      response :bad_request
      response :forbidden
      response :unauthorized
    end

    send :define_method, action do
      @user.update_status(action)
      render 'show', status: :ok
    end
  end

  swagger_api :show do
    summary 'Display a users details'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :bad_request
    response :forbidden
    response :unauthorized
  end

  def show
  end

  swagger_api :details do
    summary 'Display a users details'
    param :path, :username, :string, :required, 'user_name'
    response :ok
    response :bad_request
    response :forbidden
    response :unauthorized
  end

  def details
    @user = User.find_by_user_name(params[:username])
    render 'show'
  end

  private
  def create_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_name, :first_name, :last_name, :profile_pic)
  end

  def update_params
    params.require(:user).permit(:email, :user_name, :first_name, :last_name, :profile_pic)
  end

    # def load_user
    #   @user = User.find(params[:id])
    # end
end
