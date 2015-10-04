# == Class: calico
#
class calico::compute (
  $bird_template           = $calico::compute_bird_template,
  $compute_package         = $calico::compute_package,
  $compute_package_ensure  = $calico::compute_package_ensure,
  $etcd_host               = $calico::compute_etcd_host,
  $etcd_port               = $calico::compute_etcd_port,
  $felix_enable            = $calico::felix_enable,
  $felix_template          = $calico::felix_template,
  $metadata_service_enable = $calico::compute_metadata_service_enable,
  $manage_bird_config      = $calico::compute_manage_bird_config,
  $manage_dhcp_agent       = $calico::compute_manage_dhcp_agent,
  $manage_metadata_service = $calico::compute_manage_metadata_service,
  $manage_peers            = $calico::compute_manage_peers,
  $manage_sysctl_settings  = $calico::compute_manage_sysctl_settings,
  $manage_qemu_settings    = $calico::compute_manage_qemu_settings,
  $peer_defaults           = {},
  $peer_template           = $calico::compute_peer_template,
  $peers                   = {},
  $router_id               = $calico::router_id,
) {

  validate_bool($felix_enable)
  validate_bool($metadata_service_enable)
  validate_bool($manage_bird_config)
  validate_bool($manage_dhcp_agent)
  validate_bool($manage_metadata_service)
  validate_bool($manage_peers)
  validate_bool($manage_sysctl_settings)
  validate_bool($manage_qemu_settings)
  validate_hash($peer_defaults)
  validate_hash($peers)
  validate_ipv4_address($router_id)

  if $manage_dhcp_agent { include 'neutron::agents::dhcp' }
  if $manage_sysctl_settings { include 'calico::compute::sysctl' }
  if $manage_qemu_settings { include 'calico::compute::qemu' }

  package { $compute_package:
    ensure => $compute_package_ensure,
  }

  file { $calico::felix_conf:
    ensure  => present,
    content => template($felix_template)
  }

  service { $calico::felix_service:
    ensure => running,
    enable => $felix_enable,
  }

  Class['neutron'] ->
  Package[$calico::compute_package] ->
  File[$calico::felix_conf] ~>
  Service[$calico::felix_service]

  if $manage_metadata_service {
    package { $calico::compute_metadata_package:
       ensure => installed,
    }
    service { $calico::compute_metadata_service:
      ensure => running,
      enable => $calico::compute_metadata_service_enable,
    }
    Package[$calico::compute_metadata_package] ~>
    Service[$calico::compute_metadata_service]
  }

  if $manage_bird_config {
    contain 'calico::bird'
  }

  if $manage_peers {
    contain 'calico::bird'
    $peer_resources = keys($peers)
    calico::bird::peers { $peer_resources:
      peer_defaults => $peer_defaults,
      peer_template => $peer_template,
      peers         => $peers,
    }
  }

}
