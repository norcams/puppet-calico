# == Class: calico
#
class calico::compute (
  $compute_bird_template           = $calico::compute_bird_template,
  $compute_metadata_service_enable = $calico::compute_metadata_service_enable,
  $compute_service_enable          = $calico::compute_service_enable,
  $compute_service_template        = $calico::compute_service_template,
  $manage_dhcp_agent               = $calico::compute_manage_dhcp_agent,
  $manage_peers                    = $calico::compute_manage_peers,
  $manage_qemu_settings            = $calico::compute_manage_qemu_settings,
  $peer_defaults                   = {},
  $peer_template                   = $calico::compute_peer_template,
  $peers                           = {},
  $router_id                       = $calico::router_id,
) {

  validate_bool($manage_dhcp_agent)
  validate_bool($manage_peers)
  validate_bool($manage_qemu_settings)

  if $manage_dhcp_agent { include 'neutron::agents::dhcp' }
  if $manage_qemu_settings { include 'calico::compute::qemu' }

  package { $calico::compute_package:
    ensure => installed,
  }

  file { $calico::compute_service_conf:
    ensure  => present,
    content => template($calico::compute_service_template)
  }

  service { $calico::compute_service:
    ensure => running,
    enable => $calico::compute_service_enable,
  }

  Package[$calico::compute_package] ->
  File[$calico::compute_service_conf] ~>
  Service[$calico::compute_service]

  package { $calico::compute_metadata_package:
    ensure => installed,
  }

  service { $calico::compute_metadata_service:
    ensure => running,
    enable => $calico::compute_metadata_service_enable,
  }

  Package[$calico::compute_metadata_package] ~>
  Service[$calico::compute_metadata_service]

  if $manage_peers {
    contain 'calico::bird'
    $peer_resources = keys($peers)
    calico::compute::peers { $peer_resources:
      peer_defaults => $peer_defaults,
      peer_template => $peer_template,
      peers         => $peers,
    }
  }

}
