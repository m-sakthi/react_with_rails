class User < ApplicationRecord
  rolify
  before_save :ensure_authentication_token, if: lambda { |entry| entry[:authentication_token].blank? }
  before_save :set_status, on: :create, if: lambda { |entry| entry[:status].blank? }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, uniqueness: {case_sensitive: false},
                    presence: true,
                    length: { maximum: 255 },
                    format: { with: EMAIL_REGEX })
  validates :user_name, uniqueness: true, allow_blank: false
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  # validates :type, presence: true
  
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_nil: true

  enum status: [:not_activated, :active, :blocked, :deleted]
  # enum type: [:customer, :enterprise]

  module Status
    NOT_ACTIVATED = 'not_activated'
    ACTIVE = 'active'
    BLOCKED = 'blocked'
    DELETED = 'deleted'
    ALL = User::Status.constants.map{ |status| User::Status.const_get(status) }.flatten.uniq
  end

  # module Type
  #   CUSTOMER = 'customer'
  #   ENTERPRISE = 'enterprise'
  #   ALL = User::Type.constants.map{ |type| User::Type.const_get(type) }.flatten.uniq
  # end

  module Settings
    SESSION_EXPIRY = 86400    # in seconds
    RECORDS_LIMIT = 20
  end


  def generate_api_key
    api_key = new_token
    Rails.cache.write(User.cached_api_key(api_key),
                      self.authentication_token,
                      expires_in: Settings::SESSION_EXPIRY )
    api_key
  end

  def self.from_api_key(api_key, renew = false)
    cached_key = User.cached_api_key(api_key)
    authentication_token = Rails.cache.read cached_key
    if authentication_token
      user = User.find_by_authentication_token authentication_token
    end
    if renew and user
      Rails.cache.write(cached_key,
                        authentication_token,
                        expires_in: Settings::SESSION_EXPIRY )
    end
    user
  end

  def self.cached_api_key(api_key)
    "api/#{api_key}"  
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def update_status(action)
    status = case action
      when :activate
        Status::ACTIVE
      when :destroy
        Status::DELETED
      when :block
        Status::BLOCKED
    end
    update_attribute(:status, status)
  end

  def send_activation_email
    UserMailer.activation(self)
  end

  def password_reset_email
    UserMailer.password_reset(self)
  end

  def is_admin?
    self.has_role? :admin
  end

  def validate_and_asign_role(activity, role, resource = nil)
    role_exists = self.has_role? role.to_sym, resource
    case activity
    when _('views.role.create')
      if role_exists
        raise Sblog::Exception::InvalidParameter.new(_('errors.role_already_exist'))
      else
        self.add_role(role.to_sym)
      end
    when _('views.role.destroy')
      unless role_exists
        raise Sblog::Exception::InvalidParameter.new(_('errors.role_not_exist'))
      else
        self.remove_role(role.to_sym)
      end
    end
  end

  private
    def ensure_authentication_token
      self.authentication_token = new_token  
    end

    def set_status
      self.status = Status::NOT_ACTIVATED
    end
end
