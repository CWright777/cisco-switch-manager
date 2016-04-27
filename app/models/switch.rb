include SNMP_Polling
class Switch < ActiveRecord::Base
  attr_accessor :bandwidth_in, :up_time

  belongs_to :user
  has_many :ports

  before_validation do
    switch_info = poll_switch_info self
    self.serial = switch_info[:serial]
    self.name = switch_info[:name]
    self.contacted_at = switch_info[:contacted_at]
  end

  after_create do
    create_ports
  end

  
  def create_ports
    poll_ports_info self
  end
  def get_up_time
    poll_switch_uptime self
  end

  def get_input_bandwidth
    poll_switch_input_bandwidth self
  end

  def active_ports
    count = 0
    self.ports.each do |port|
      if port.status == "active"
        count += 1
      end
    end
    count
  end

  def as_json(options = {})
    super(options.merge(include: :ports))
  end
end
