class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  has_many :comments
  has_many :attendances
  has_many :attendees, through: :attendances, source: :user
  validates :name, :location, :user, :date, presence: true
  validate :event_date_cannot_be_in_the_past
  def date_display
    self.date.strftime("%B %-d, %Y")
  end
  private
  def event_date_cannot_be_in_the_past
    errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
  end
end
