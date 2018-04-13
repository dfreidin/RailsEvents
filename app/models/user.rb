class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  belongs_to :location
  has_many :events
  has_many :comments
  has_many :attendances
  has_many :events_attending, through: :attendances, source: :event
  validates :first_name, :last_name, :email, :location, presence: true
  validates :password, presence: true, length: {minimum: 8}, on: :create
  validates :email, format: {with: EMAIL_REGEX}, uniqueness: {case_sensitive: false}
end
