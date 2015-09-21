# == Class: calico
#
class calico::compute (
  $manage_bird = true,
  $peers       = {},
) inherits calico::params {

  include 'calico::compute::qemu'
  include 'neutron::agents::dhcp'

  package { $calico::params::compute_package:
    ensure => installed,
  }

  exec { 'cp_default_config':
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    command => 'cp /etc/calico/felix.cfg.example /etc/calico/felix.cfg',
    unless  => 'test -f /etc/calico/felix.cfg',
  }

  service { $calico::params::compute_service:
    ensure => running,
  }

  package { $calico::params::compute_metadata_package:
    ensure => installed,
  }

  service { $calico::params::compute_metadata_service:
    ensure => running,
  }

  if $manage_bird {
    include 'calico::bird'
    calico::compute::peer { $calico::compute::peers: }
  }

  # Install the package, then copy the configuration and notify the service
  Package[$calico::params::compute_package] ->
  Exec['cp_default_config'] ~>
  Service[$calico::params::compute_service]

  Package[$calico::params::compute_metadata_package] ~>
  Service[$calico::params::compute_metadata_service]

}
