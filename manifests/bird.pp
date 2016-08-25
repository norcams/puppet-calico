#
class calico::bird {
  include 'bird::params'

  $birdconfd = '/etc/bird/bird.conf.d'
  $bird6confd = '/etc/bird/bird6.conf.d'

  file { '/etc/bird':
    ensure => directory,
  }

  # Select bird config templates according to enabled role
  if $calico::compute::manage_bird_config {
    $bird_template  = $calico::compute::bird_template
    $bird6_template = $calico::compute::bird6_template
  } elsif $calico::reflector::manage_bird_config {
    $bird_template  = $calico::reflector::bird_template
    $bird6_template = $calico::reflector::bird6_template
  }

  # Manage bird.conf and bird6.conf
  #
  # Note: bird will fail if the path in the 'include' statement does
  #       not exist when the service starts
  #
  if $calico::compute::manage_bird_config or $calico::reflector::manage_bird_config {
    if $calico::enable_ipv4 {
      file { $birdconfd:
        ensure => directory,
      }
      file { $bird::params::config_path_v4:
        ensure  => present,
        content => template($bird_template),
      }
      File[$birdconfd] -> File[$bird::params::config_path_v4] ~>
      Service[$bird::params::daemon_name_v4]
    }
    if $calico::enable_ipv6 {
      file { $bird6confd:
        ensure => directory,
      }
      file { $bird::params::config_path_v6:
        ensure  => present,
        content => template($bird6_template),
        notify => Service[$bird::params::daemon_name_v6],
      }
      File[$bird6confd] -> File[$bird::params::config_path_v6] ~>
      Service[$bird::params::daemon_name_v6]
    }
  }

}
