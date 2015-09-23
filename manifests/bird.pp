#
class calico::bird {
  include 'bird::params'

  $birdconfd = '/etc/bird/bird.conf.d'
  $bird6confd = '/etc/bird/bird6.conf.d'

  file { '/etc/bird':
    ensure => directory,
  }

  if $calico::enable_ipv4 {
    file { $birdconfd:
      ensure => directory,
    }
    file { $bird::params::config_path_v4:
      ensure  => present,
      content => template('calico/compute/bird.conf.erb'),
    }
  }

  if $calico::enable_ipv4 {
    file { $bird6confd:
      ensure => directory,
    }
    file { $bird::params::config_path_v6:
      ensure  => present,
      content => template('calico/compute/bird6.conf.erb'),
    }
  }

}
