class SwitchesController < ApplicationController

  def index
    @switches = current_user.switches.all
    @switches.each do |switch|
      switch.get_up_time
      switch.get_input_bandwidth
    end
    respond_to do |format|
      format.json {render :index}
    end
  end

  #Save switch and ports
  def create
    #Create switch and ports
    @switch = Switch.create(switch_params)
    redirect_to switches_path
  end   

  def show
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
    p @switch
    respond_to do |format|
      format.json {render :show}
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
    if params[:name]
      ssh.change_hostname params[:name]
      current_switch.update(name: params[:name])
    end
    p params
    if params[:notes]
      current_switch.update(notes: params[:notes])
    end
    @switch = Switch.find(params[:id])
    respond_to do |format|
      format.json {render :index}
    end
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

  def destroy
    @switch = Switch.find(params[:id])
    @switch.destroy
    respond_to do |format|
      format.json {render :index}
    end
  end


  private
    def switch_params
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
