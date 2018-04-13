class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :comment, :user, :event, presence: true
end
