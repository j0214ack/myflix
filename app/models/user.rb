class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items

  validates :email, presence: true, uniqueness: true
  validates :password, on: :create, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  validates :full_name, presence: true
end
