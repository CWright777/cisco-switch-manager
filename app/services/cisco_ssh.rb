class Cisco_ssh < SSH
  attr_accessor :config, :users
  def initialize(creds)
    @host = creds[:host]
      
    creds[:prompt] = /.*>|.*#/
    super(creds)
    unless @errors
      @ssh.cmd("en\r#{creds[:enable_password]}")
      @ssh.cmd("term len 0")
      # @config = @ssh.cmd("show run")
      # get_users
    else
      p @errors
    end
  end
  
  def enable(pass)
    @ssh.cmd("en\r#{pass}")
  end
  
  def termlen=(length)
    @ssh.cmd("term len #{length}")
  end
  
  def close
    termlen=24
    @ssh.close
  end
  
  def update_config
    p @d.lines.inspect
    @d = @ssh.cmd("host alpdddddssdha")
    # p @d.lines.inspect
    
    # get_users
  end

  def enable_port port_name
    @d = @ssh.cmd("config t")
    @ssh.cmd("int #{port_name}")
    @ssh.cmd("no shut")
  end

  def disable_port port_name
    @d = @ssh.cmd("config t")
    @ssh.cmd("int #{port_name}")
    @ssh.cmd("shut")
  end

  def change_hostname name
    p @ssh
    @d = @ssh.cmd("config t")
    @d.lines.each do |x|
    end
    @config = @ssh.cmd("host #{name}")
    @config.lines.each do |r|
      p r
    end
    # get_users
  end

  private
  def get_users
    @config.lines.each do |line|
      p line
      # if line.include? "username"
      #   user = {}
      #   user[:username] = line.split[1]
      #   user[:password] = line.match(/(password|secret).\d.*/)[0].split[2]
      #   @users.push(user)
      # end
    end
  end
end