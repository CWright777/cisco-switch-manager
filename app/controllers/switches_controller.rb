class SwitchesController < ApplicationController

  def index
  end

  def create
    @switch = Switch.create(switch_params)
    # @switch = Switch.find(1)
    @port = {}
    table_columns = ["ifIndex","ifDescr", "ifHCInOctets","ifHCOutOctets","ifPhysAddress"]
    SNMP::Manager.open(:host => @switch.ipaddress, community: @switch.community) do |manager|
    # SNMP::Manager.open(:host => "172.16.1.3", community: "password") do |manager|
      manager.walk(table_columns) do |row|
        temp = ""
        row.each_with_index do |vb,i|
          if i == 0
            @port["#{vb.value}"] = {}
            @port["#{vb.value}"][:int_idx] = "#{vb.value}"
            temp = "#{vb.value}"
          elsif i == 1
            @port[temp][:port_name] = "#{vb.value}"
          elsif i == 2
            @port[temp][:input] = Integer("#{vb.value}") if "#{vb.value}" != "noSuchInstance"
          elsif i == 3
            @port[temp][:output] = Integer("#{vb.value}") if "#{vb.value}" != "noSuchInstance"
          else
            @port[temp][:mac_address] = "#{vb.value.unpack("H2H2H2H2H2H2").join(":")}"
            @port[temp][:switch] = @switch
            @port[temp][:status] = "inactive"
          end
        end
      end
    end
    @port.each do |port,info|
      unless info[:port_name].include?("Eth")
        @port.delete(port)
      end
    end
    @port.each do |port,attributes|
      Port.create(attributes)
    end
    redirect_to dashboard_index_path
  end   

  def show
    @switch_model = Switch.new
    @switch = Switch.find(params[:id])
    @ports = []
    @switch.ports.each do |port|
      @ports.append(port)
    end
    @port_status = {}
    SNMP::Manager.open(:host => @switch.ipaddress, community: @switch.community) do |manager|
      manager.walk(["ifIndex","ifOperStatus"]) do |row|
        @port_status["#{row[0].value}"] = "#{row[1].value}"
      end
    end
    # .sort{|port| port["int_idx"] }.reverse
  end

  def update
    current_switch = Switch.find(params[:id])
    ssh_info = {host: current_switch.ipaddress, user: current_switch.user_name, password: current_switch.switch_password,enable_password: current_switch.enable_password}
    ssh = Cisco_ssh.new ssh_info
    ssh.change_hostname params[:switch][:name]
    current_switch.update(name: params[:switch][:name])
    redirect_to :back
  end

  def enable
    splitted = params[:id].split("h")
    current_switch = Switch.find(splitted[0])
    ssh_info = {host: current_switch.ipaddress, user: current_switch.user_name, password: current_switch.switch_password,enable_password: current_switch.enable_password}
    ssh = Cisco_ssh.new ssh_info
    port = Port.find(splitted[1])
    ssh.enable_port port.port_name
    redirect_to :back
  end

  def disable
    splitted = params[:id].split("h")
    current_switch = Switch.find(splitted[0])
    ssh_info = {host: current_switch.ipaddress, user: current_switch.user_name, password: current_switch.switch_password,enable_password: current_switch.enable_password}
    ssh = Cisco_ssh.new ssh_info
    port = Port.find(splitted[1])
    ssh.disable_port port.port_name
    redirect_to :back
  end

  private
    def switch_params
      #Gets serial, name
      SNMP::Manager.open(host: params[:switch][:ipaddress], community: params[:switch][:community]) do |manager|
          manager.walk(["1.3.6.1.4.1.9.3.6.3","sysName"]) do |row|
            @serial = "#{row[0].value}"
            @name = "#{row[1].value}".split(".")[0]
          end
      end
      params.require(:switch).permit(:ipaddress,:user_name,:switch_password,:community, :enable_password).merge(user: current_user, contacted_at: DateTime.now, serial: @serial, name: @name)
    end
end
