class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable,
  # :timeoutable, :trackable, :registerable, :recoverable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :token_authenticatable

  after_create :create_auth_token
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def self.blacklist_keys
    @blacklist_keys ||= super - ["id"]
  end

  private

  def create_auth_token
    ensure_authentication_token!
  end
end
