include SNMP_Polling
class Switch < ActiveRecord::Base

  belongs_to :user
  has_many :ports

  before_validation do
    poll_switch_info self
  end
end
