class Location < ActiveRecord::Base
    before_validation :upper_state
    has_many :users
    has_many :events
    validates :city, :state, presence: true
    validates :state, length: {is: 2}
    private
    def upper_state
        self.state.upcase!
    end
end
