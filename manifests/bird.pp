#
class calico::bird {
  include 'bird::params'

  $birdconfd = '/etc/bird/bird.conf.d'
  $bird6confd = '/etc/bird/bird6.conf.d'


  # Set bird config template according to role if enabled
  if $calico::compute_manage_bird_config {
    $bird_template  = $calico::compute_bird_template
    $bird6_template = $calico::compute_bird6_template
  } elsif $calico::reflector_manage_bird_config {
    $bird_template  = $calico::reflector_bird_template
    $bird6_template = $calico::reflector_bird6_template
  }

  # Manage bird.conf and bird6.conf
  if $calico::compute_manage_bird_config or $calico::reflector_manage_bird_config {
    if $calico::enable_ipv4 {
      file { $bird::params::config_path_v4:
        ensure  => present,
        content => template($bird_template),
        notify => Service[$bird::params::daemon_name_v4],
      }
    }
    if $calico::enable_ipv6 {
      file { $bird::params::config_path_v6:
        ensure  => present,
        content => template($bird6_template),
        notify => Service[$bird::params::daemon_name_v6],
      }
    }
  }

  # Set up include dirs if we manage compute peers or reflector clients
  if $calico::compute_manage_peers or $calico::reflector_manage_clients {
    file { '/etc/bird':
      ensure => directory,
    }
    if $calico::enable_ipv4 {
      file { $birdconfd:
        ensure => directory,
      }
    }
    if $calico::enable_ipv6 {
      file { $bird6confd:
        ensure => directory,
      }
    }
  }

}
