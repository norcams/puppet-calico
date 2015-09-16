# == Class: calico
#
class calico::compute (
) inherits calico::params {

  include ::calico::compute::qemu
  include ::neutron::agents::dhcp

  package { $compute_metadata_package:
    ensure => installed,
  }

  service { $compute_metadata_service:
    ensure => running,
  }

  package { $compute_package:
    ensure => installed,
  }

  service [

  exec { 'cp_default_config':
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
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

  Package[$compute_metadata_package] ~>
  Service[$compute_metdata_service]

}
