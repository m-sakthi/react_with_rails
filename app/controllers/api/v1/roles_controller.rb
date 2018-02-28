class Api::V1::RolesController < ApplicationController

  swagger_controller :roles, "Roles Management"

  [_('views.role.create'), _('views.role.destroy')].each do |action|
    swagger_api action.to_sym do
      summary "#{action.capitalize}'s role"
      param :query, :user_id, :array, :required, 'User Id'
      param_list :query, :role, :string, :required, "Role to be assigned", Role::Privileges::ALL
      response :ok
      response :forbidden
      response :bad_request
      response :unauthorized
    end

    send :define_method, action do
      authorize! "save_#{params[:role]}".to_sym, current_user
      user_id = params[:user_id]
      # user_ids = params[:user_ids].is_a?(String) ? params[:user_ids].split(",") : params[:user_ids]
      # raise Sblog::Exception::InvalidParameter.new(_('errors.invalid_user_ids')) if user_id.blank?
      # users = User.where(id: user_ids)
      # users.each do |user|
      #   user.validate_and_asign_role(action, params[:role])
      # end
      user = User.find(user_id)
      user.validate_and_asign_role(action, params[:role])
      head :ok
    end
  end

  swagger_api :users_list do
    summary 'Fetches the users for the given role'
    param_list :query, :role, :string, :required, "roles_list", Role::Privileges::ALL
    param :query, :page, :integer, :optional, "Page Number"
    response :ok
    response :forbidden
    response :bad_request
    response :unauthorized
  end

  def users_list
    authorize! :users_list, current_user
    @users = User.with_role(params[:role]).distinct
    @users = @users.page(params[:page]).per(User::Settings::RECORDS_LIMIT).order('id ASC')
    render 'api/v1/users/index'
  end

end
