#
define calico::reflector::client(
  $ensure     = 'present',
  $local_as   = 65535,
  $local_ip   = $ipaddress,
  $client_as  = 65535,
  $client_ip,
  $protocol   = 'ipv4',
  $template   = undef,
) {
  validate_integer($client_as)
  validate_integer($local_as)

  # Handle defaults
  if $template == undef {
    $real_template = 'calico/reflector/client.erb'
  } else {
    $real_template = $template
  }

  # Remove dots in filename
  $filename = regsubst($name, '\.', '_', 'G')

  case $protocol {
    /(?i-mx:ipv4)/: {
      # Verify addresses
      validate_ipv4_address($local_ip)
      validate_ipv4_address($client_ip)

      file { "${calico::bird::birdconfd}/${filename}.conf":
        ensure  => $ensure,
        content => template($real_template),
      }
    }
    /(?i-mx:ipv6)/: {
      # Verify addresses
      validate_ipv6_address($local_ip)
      validate_ipv6_address($client_ip)

      file { "${calico::bird::bird6conf}/${filename}.conf":
        ensure  => $ensure,
        content => template($real_template),
      }
    }
    default: { fail("Invalid ip protocol: $protocol") }
  }
}
