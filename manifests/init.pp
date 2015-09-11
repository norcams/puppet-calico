# == Class: calico
#
class calico::compute (
) inherits calico::params {

  package { 'calico-compute':
    ensure => installed,
  }

  exec { 'cp_default_config':
    command => 'cp /etc/calico/felix.cfg.example /etc/calico/felix.cfg',
    unless  => 'test -f /etc/calico/felix.cfg',
  }

  service { 'calico-felix':
    ensure => running,
  }

  # Install the package, then copy the configuration and notify the service
  Package['calico-compute'] ->
  Exec['cp_default_config'] ~>
  Service['calico-feliẍ́']

}
