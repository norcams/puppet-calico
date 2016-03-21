#
define calico::bird::peer(
  $ensure   = 'present',
  $local_as = 65535,
  $local_ip = $ipaddress,
  $peer_as  = 65535,
  $peer_ip,
  $local_pref = 100,
  $protocol = 'ipv4',
  $template,
) {
  validate_integer($peer_as)
  validate_integer($local_as)

  # Remove dots in filename
  $filename = regsubst($name, '\.', '_', 'G')

  case $protocol {
    /(?i-mx:ipv4)/: {
      validate_ipv4_address($local_ip)
      validate_ipv4_address($peer_ip)

      file { "${calico::bird::birdconfd}/${filename}.conf":
        ensure  => $ensure,
        content => template($template),
        notify  => Service[$bird::params::daemon_name_v4],
      }
    }
    /(?i-mx:ipv6)/: {
      validate_ipv6_address($local_ip)
      validate_ipv6_address($peer_ip)

      file { "${calico::bird::bird6confd}/${filename}.conf":
        ensure  => $ensure,
        content => template($template),
        notify  => Service[$bird::params::daemon_name_v6],
      }
    }
    default: { fail("Invalid ip protocol: $protocol") }
  }

}
