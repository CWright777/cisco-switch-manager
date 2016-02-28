require 'rubygems'
require 'net/ssh'
require 'net/ssh/telnet'

class SSH
  attr_accessor :errors
  
  def initialize(creds)
    begin
      @ssh_session = Net::SSH.start(creds[:host], creds[:user], :password => creds[:password], :keys => [])
      @ssh = Net::SSH::Telnet.new("Session" => @ssh_session, "Prompt" => creds[:prompt])
      @errors = false
    rescue Exception => e
      @errors = e
    end
  end
  
  def cmd(command)
    @ssh.cmd(command)
  end
  
  def close
    @ssh.close
  end
    
end

class Cisco_ssh < SSH
  attr_accessor :config, :users
  def initialize(creds)
    @host, @users = creds[:host], []
      
    creds[:prompt] = /.*>|.*#/
    super(creds)
    unless @errors
      @ssh.cmd("en\r#{creds[:enable]}")
      @ssh.cmd("term len 0")
      # @config = @ssh.cmd("show run")
      # get_users
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
    @d = @ssh.cmd("config t")
    p @d.lines.inspect
    @d = @ssh.cmd("host sddssssss")
    p @d.lines.inspect
    
    # get_users
  end

  def host
    @config = @ssh.cmd("host ssss")
    get_users
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