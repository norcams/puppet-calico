#
define calico::bird::peer(
  $ensure     = 'present',
  $local_as   = 65535,
  $local_ip   = fact('ipaddress'),
  $local_ipv6 = fact('ipaddress6'),
  $peer_as    = 65535,
  $peer_ip,
  $peer_ipv6  = undef,
  $local_pref = undef,
  $protocol   = 'ipv4',
  $template,
) {
  validate_integer($peer_as)
  validate_integer($local_as)

  # For newer el releases the daemon name is the same
  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease >= '8') {
    $daemon_name_v6 = $bird::daemon_name_v4
  }
  else {
    $daemon_name_v6 = $bird::daemon_name_v6
  }

  # Remove dots in filename
  $filename = regsubst($name, '\.', '_', 'G')

  case $protocol {
    /(?i-mx:ipv4)/: {
      validate_ipv4_address($local_ip)
      validate_ipv4_address($peer_ip)

      file { "${calico::bird::birdconfd}/${filename}.conf":
        ensure  => $ensure,
        content => template($template),
        notify  => Service[$bird::daemon_name_v4],
      }
    }
    /(?i-mx:ipv6)/: {
      validate_ipv6_address($local_ip)
      validate_ipv6_address($peer_ip)

      file { "${calico::bird::bird6confd}/${filename}.conf":
        ensure  => $ensure,
        content => template($template),
        notify  => Service[$daemon_name_v6],
      }
    }
    default: { fail("Invalid ip protocol: $protocol") }
  }

}
