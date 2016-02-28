class Switch < ActiveRecord::Base
  belongs_to :user
  has_many :ports
end
