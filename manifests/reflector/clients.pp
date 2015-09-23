#
define calico::reflector::clients(
  $client_defaults,
  $client_template = undef,
  $clients,
) {
  validate_hash($client_defaults)
  validate_hash($clients)

  $client = $clients[$name]

  if has_key($client, 'ipv4') {
    calico::reflector::client { "${name}_ipv4":
      protocol => 'ipv4',
      client_ip  => $client['ipv4'],
      client_as  => $client['client_as'],
      local_as => $client['local_as'],
      local_ip => $client['local_ip'],
      template => $client['client_template'],
    }
  }

  if has_key($client, 'ipv6') {
    calico::reflector::client { "${name}_ipv6":
      protocol => 'ipv6',
      client_ip  => $client['ipv6'],
      client_as  => $client['client_as'],
      local_as => $client['local_as'],
      local_ip => $client['local_ip'],
      template => $client['client_template'],
    }
  }

}
