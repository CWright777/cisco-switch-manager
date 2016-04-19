json.switches @switches do |switch|
  json.id switch.id
  json.name switch.name
  json.ipaddress switch.ipaddress
  json.contacted_at switch.contacted_at
  json.activePorts switch.active_ports
  json.totalPorts switch.ports.count
  json.bandwidthIn switch.bandwidth_in
  json.upTime switch.up_time
end
