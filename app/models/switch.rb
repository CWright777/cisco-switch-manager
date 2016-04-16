include SNMP_Polling
class Switch < ActiveRecord::Base

  belongs_to :user
  has_many :ports

  before_validation do
    switch_info = poll_switch_info self
    self.serial = switch_info[:serial]
    self.name = switch_info[:name]
    self.contacted_at = switch_info[:contacted_at]
  end
end
