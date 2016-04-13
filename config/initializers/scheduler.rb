require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '7s' do
  unless Switch.all.none.is_a?(ActiveRecord::NullRelation)
    Switch.all.each do |switch|
      begin
        @inputs = {}
        @outputs = {}
        SNMP::Manager.open(:host => switch.ipaddress, community: switch.community) do |manager|
          switch.update_attribute(:contacted_at, DateTime.now)
          manager.walk(["ifIndex","ifHCInOctets","ifHCOutOctets"]) do |row|
            begin
              @inputs[Integer("#{row[0].value}")] = Integer("#{row[1].value}")
              @outputs[Integer("#{row[0].value}")] = Integer("#{row[2].value}")
            rescue
            end
          end
        end
        switch.ports.each do |port|
          if @inputs[port.int_idx] == port.input and port.status == "active"
            port.update_attribute(:status, "inactive")
          elsif @inputs[port.int_idx] != port.input
            unless port.status == "active"
              port.update_attribute(:status, "active") 
            end
            port.update_attribute(:input, @inputs[port.int_idx])
          end
          unless @outputs[port.int_idx] == port.output
            port.update_attribute(:output,@outputs[port.int_idx])
          end
        end
      rescue
      end           
    end
  end
end
