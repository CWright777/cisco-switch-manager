class SwitchesController < ApplicationController

  def index
  end

  #Save switch and ports
  def create
    #Create switch and ports
    @switch, @ports = Switch.create(switch_params), {}
    p @switch
    
    #SNMP column names
    table_columns = ["ifIndex","ifDescr", "ifHCInOctets","ifHCOutOctets","ifPhysAddress"]

    #Credentials for polling SNMP
    creds = {
      host: @switch.ipaddress,
      community: @switch.community
    }

    #Poll SNMP. through each column and get port information from switch. Parse information
    #from tables_columns
    snmp_walk creds, table_columns do |row|
      temp = ""
      row.each_with_index do |vb,i|
        if i == 0
          @ports["#{vb.value}"] = {}
          @ports["#{vb.value}"][:int_idx] = "#{vb.value}"
          temp = "#{vb.value}"
        elsif i == 1
          @ports[temp][:port_name] = "#{vb.value}"
        elsif i == 2
          @ports[temp][:input] = Integer("#{vb.value}") if "#{vb.value}" != "noSuchInstance"
        elsif i == 3
          @ports[temp][:output] = Integer("#{vb.value}") if "#{vb.value}" != "noSuchInstance"
        else
          @ports[temp][:mac_address] = "#{vb.value.unpack("H2H2H2H2H2H2").join(":")}"
          @ports[temp][:switch] = @switch
          @ports[temp][:status] = "inactive"
        end
      end
    end

    #Delete port information from non-ethernet interfaces
    @ports.each do |port,info|
      unless info[:port_name].include?("Eth")
        @ports.delete(port)
      end
    end

    #Create ports
    @ports.each do |ports,attributes|
      Port.create(attributes)
    end

    #Redirect back to dashboard
    redirect_to dashboard_index_path
  end   

  def show
    #Switch model for simple form, used for switch hostname change
    @switch_model = Switch.new

    #Find switch from id given in parameters
    @switch = Switch.find(params[:id])

    #Get interface's operational/link status and interface index
    creds = {
      host: @switch.ipaddress,
      community: @switch.community
    }
    @ports = []
    @switch.ports.each do |port|
      @ports.append(port)
    end
    @port_status = {}
    snmp_walk creds, ["ifIndex","ifOperStatus"] do |row|
      @port_status["#{row[0].value}"] = "#{row[1].value}"
    end
  end

  def update
    current_switch = Switch.find(params[:id])
    ssh_info = {
      host: current_switch.ipaddress,
      user: current_switch.user_name,
      password: current_switch.switch_password,
      enable_password: current_switch.enable_password
    }
    ssh = Cisco_ssh.new ssh_info
    ssh.change_hostname params[:switch][:name]
    current_switch.update(name: params[:switch][:name])
    redirect_to :back
  end

  def enable
    splitted = params[:id].split("h")
    current_switch = Switch.find(splitted[0])
    ssh_info = {
      host: current_switch.ipaddress,
      user: current_switch.user_name,
      password: current_switch.switch_password,
      enable_password: current_switch.enable_password
    }
    ssh = Cisco_ssh.new ssh_info
    port = Port.find(splitted[1])
    ssh.enable_port port.port_name
    redirect_to :back
  end

  def disable
    splitted = params[:id].split("h")
    current_switch = Switch.find(splitted[0])
    ssh_info = {
      host: current_switch.ipaddress,
      user: current_switch.user_name,
      password: current_switch.switch_password,
      enable_password: current_switch.enable_password
    }
    ssh = Cisco_ssh.new ssh_info
    port = Port.find(splitted[1])
    ssh.disable_port port.port_name
    redirect_to :back
  end

  private
    def switch_params
      #creds = {
        #host: params[:switch][:ipaddress],
        #community: params[:switch][:community]
      #}

      #table_columns = [
        #"1.3.6.1.4.1.9.3.6.3",#Switch Serial Number (Object Identifier)
        #"sysName"#Hostname
      #]

      #Gets serial, name
      #snmp_walk creds, table_columns do |row|
        #@serial = "#{row[0].value}"
        #@name = "#{row[1].value}".split(".")[0]
      #end

      params
      .require(:switch)
      .permit(:ipaddress,
              :user_name,
              :switch_password,
              :community,
              :enable_password
             )
      .merge(user: current_user)
    end
end
