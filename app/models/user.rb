class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :collaborators
  has_many :wikis, through: :collaborators

  attr_accessor :login

  validates :username, presence: :true, uniqueness: { case_sensitive: false }

  validate :validate_username


  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  enum role: [:standard, :premium, :admin]

  after_initialize { self.role ||= :standard }

end
