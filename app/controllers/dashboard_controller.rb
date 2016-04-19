include SNMP_Polling

class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def show
    #SNMP::MIB.import_module("/Users/CDawg/Documents/Coding_Dojo_Assignments/Project/MerakiClone/OLD-CISCO-INTERFACES-MIB.oid")
    @switches = current_user.switches.all
    @switches.each do |switch|
      switch.get_up_time
      switch.get_input_bandwidth
    end
    #@switches.each do |switch|
      #table_columns = ["ifHCInOctets","ifDescr"]
      #switch.bandwidth_in = []
      #SNMP::Manager.open(:host => switch.ipaddress, community: switch.community) do |manager|
        #manager.walk(table_columns) do |row|
          #row.each { |vb|  switch.bandwidth_in.push vb.value}
        #end
      #end
    #end
    respond_to do |format|
      format.json {render :index}
    end
  end
end
