# == Class: calico
#
class calico::compute (
) inherits calico::params {

  package { $compute_package:
    ensure => installed,
  }

  exec { 'cp_default_config':
    command => 'cp /etc/calico/felix.cfg.example /etc/calico/felix.cfg',
    unless  => 'test -f /etc/calico/felix.cfg',
  }

  service { $compute_service:
    ensure => running,
  }

  # Install the package, then copy the configuration and notify the service
  Package[$compute_package] ->
  Exec['cp_default_config'] ~>
  Service[$compute_service]

}
