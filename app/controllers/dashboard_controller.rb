class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def show
    #SNMP::MIB.import_module("/Users/CDawg/Documents/Coding_Dojo_Assignments/Project/MerakiClone/OLD-CISCO-INTERFACES-MIB.oid")
    @switches = current_user.switches.all
    @properties = {}
    @switches.each do |switch|
      @properties['up_time'] = {}
      SNMP::Manager.open(:host => switch.ipaddress, community: switch.community) do |manager|
        manager.walk(["sysUpTime"]) do |row|
          row.each { |vb|  @properties['up_time'][switch.id.to_s] = "#{vb.value}".slice(0..-4) }
        end
      end
    end
    @switches.each do |switch|
      @properties['bandwidth_in'] = {}
      table_columns = ["ifHCInOctets","ifDescr"]
      @properties['bandwidth_in'][switch.id.to_s] = []
      SNMP::Manager.open(:host => switch.ipaddress, community: switch.community) do |manager|
        manager.walk(table_columns) do |row|
          temp = []
          row.each { |vb|  temp.push "#{vb.value}" }
          @properties['bandwidth_in'][switch.id.to_s].push temp
        end
      end
    end
    respond_with @switches
  end
end
