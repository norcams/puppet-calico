#
class calico::bird {

  include bird

  file { '/etc/bird':
    ensure => directory,
  }

  file { '/etc/bird/bird.conf.d/':
    ensure => directory,
  }

  file { '/etc/bird/bird6.conf.d/':
    ensure => directory,
  }
}
