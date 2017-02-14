module SessionsHelper
  def login(user)
    # reset_session
    # session[:user_id] = user.id
    # current_user.generate_api_key
    user.generate_api_key
  end

  def current_user
    # if (user_id = session[:user_id])
    #   @current_user ||= User.find_by(id: user_id)
    # elsif (api_key = get_evn_api_key)
    #   @current_user = User.from_api_key(api_key, true)
    # end
    api_key = get_evn_api_key
    @current_user ||= User.from_api_key(api_key, true)
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.blank?
  end

  def logout
    # session.delete(:user_id)
    env_key = get_evn_api_key
    Rails.cache.delete User.cached_api_key(env_key) if User.from_api_key(env_key)
    @current_user = nil
  end

  def get_evn_api_key
    request.env['HTTP_X_API_KEY']
  end
end