class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_person_name   
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :time_zone, presence: true
  validate :password_complexity  
  
  has_one_attached :avatar, service: ENV['PUBLIC_STORAGE_SERVICE'].to_sym do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  
  # TODO:  move this to migration
  before_validation :set_time_zone  
  def set_time_zone    
    self.time_zone = 'Sydney'
  end


  def full_name
    if first_name
      name.familiar
    else
      email
    end
  end

  def to_s
    full_name
  end

  def password_complexity
    #https://github.com/heartcombo/devise/wiki/How-To:-Set-up-simple-password-complexity-requirements
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character (for example ! or -)'
  end


  def self.ransackable_attributes(auth_object = nil)
    ["site_admin", "created_at", "email", "encrypted_password", "first_name", "id", "id_value", "last_name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "time_zone", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["avatar_attachment", "avatar_blob"]
  end
end
