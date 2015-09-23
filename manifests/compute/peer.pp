#
define calico::compute::peer(
  $ensure   = 'present',
  $local_as = 65535,
  $local_ip = $ipaddress,
  $peer_as  = 65535,
  $peer_ip,
  $protocol = 'ipv4',
  $template = undef,
) {
  validate_integer($peer_as)
  validate_integer($local_as)

  # Handle defaults
  if $template == undef {
    $real_template = 'calico/compute/peer.erb'
  } else {
    $real_template = $template
  }

  # Remove dots in filename
  $filename = regsubst($name, '\.', '_', 'G')

  case $protocol {
    /(?i-mx:ipv4)/: {
      validate_ipv4_address($local_ip)
      validate_ipv4_address($peer_ip)

      file { "${calico::bird::birdconfd}/${filename}.conf":
        ensure  => $ensure,
        content => template($real_template),
      }
    }
    /(?i-mx:ipv6)/: {
      validate_ipv6_address($local_ip)
      validate_ipv6_address($peer_ip)

      file { "${calico::bird::bird6conf}/${filename}.conf":
        ensure  => $ensure,
        content => template($real_template),
      }
    }
    default: { fail("Invalid ip protocol: $protocol") }
  }
}
