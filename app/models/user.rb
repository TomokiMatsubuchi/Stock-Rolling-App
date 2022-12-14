class User < ApplicationRecord

  paginates_per 10

  before_destroy :not_destroy_no_admin

  has_many :expendable_items, dependent: :destroy

  validates :name, presence: true
  validates :ec_login_id, presence: true, unless: -> { ec_login_password.blank? }
  validates :ec_login_password, presence: true, unless: -> { ec_login_id.blank? }

  attr_encrypted :ec_login_id, key: 'This is a key that is 256 bits!!'
  attr_encrypted :ec_login_password, key: 'This is a key that is 256 bits!!'

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, omniauth_providers: %i[line]

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  def remember_me
    false
  end

  def not_destroy_no_admin
    if User.where(admin: true).count == 1 && self.admin == true
      errors.add(:base, "管理者が0人になるため削除できません")
      throw :abort
    end
  end
end
