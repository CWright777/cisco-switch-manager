module SNMP_Polling

    def snmp_walk switch, table_columns, &block
      SNMP::Manager.open(
        host: self.ipaddress,
        community: self.community
      ) do |manager|
        manager.walk(table_columns) do |row|
          yield row
        end
      end
    end

    def poll_switch_uptime switch
      table_columns = [
        "sysUpTime"
      ]
      snmp_walk switch, table_columns do |row|
        row.each { |vb|  switch.up_time =  vb.value.instance_variable_get("@value") }
      end
    end

    def poll_switch_input_bandwidth switch
      table_columns = ["ifHCInOctets","ifDescr"]
      switch.bandwidth_in = []
      SNMP::Manager.open(:host => switch.ipaddress, community: switch.community) do |manager|
        manager.walk(table_columns) do |row|
          row.each { |vb|  switch.bandwidth_in.push vb.value}
        end
      end
    end

    def poll_switch_info switch
      switch_info = {}
      table_columns = [
        "1.3.6.1.4.1.9.3.6.3",#Switch Serial Number (Object Identifier)
        "sysName"#Hostname
      ]

      snmp_walk switch, table_columns do |row|
        switch_info[:serial] = "#{row[0].value}"
        switch_info[:name] = "#{row[1].value}".split(".")[0]
        switch_info[:contacted_at] = DateTime.now
      end
      switch_info
    end

    def poll_ports_info switch
      #SNMP column names(Interface index, interface description, interface
      #current input and output and mac address
      table_columns = [
        "ifIndex",
        "ifDescr",
        "ifHCInOctets",
        "ifHCOutOctets",
        "ifPhysAddress"
      ]

      snmp_walk switch, table_columns do |row|
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
    end
end
