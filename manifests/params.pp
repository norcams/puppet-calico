# == Class: calico::params
#
# Default parameter values
#
class calico::params {
  $compute_bird_template            = 'calico/compute/bird.conf.erb'
  $compute_bird6_template           = 'calico/compute/bird6.conf.erb'
  $compute_dhcp_agent               = 'neutron'
  $compute_etcd_host                = '127.0.0.1'
  $compute_etcd_port                = '4001'
  $compute_manage_bird_config       = true
  $compute_manage_dhcp_agent        = true
  $compute_manage_metadata_service  = true
  $compute_manage_peers             = true
  $compute_manage_sysctl_settings   = true
  $compute_manage_qemu_settings     = true
  $compute_metadata_package_default = 'openstack-nova-api'
  $compute_metadata_service_default = 'openstack-nova-metadata-api'
  $compute_metadata_service_enable  = true
  $compute_package_default          = 'calico-compute'
  $compute_package_ensure           = 'installed'
  $compute_peer_template            = 'calico/compute/peer.erb'
  $controller_etcd_host             = '127.0.0.1'
  $controller_etcd_port             = '4001'
  $controller_package_default       = 'calico-control'
  $controller_package_ensure        = 'installed'
  $enable_ipv4                      = true
  $enable_ipv6                      = true
  $felix_conf                       = '/etc/calico/felix.cfg'
  $felix_enable                     = true
  $felix_service_default            = 'calico-felix'
  $felix_template                   = 'calico/compute/felix.cfg.erb'
  $felix_vxlan_port                 = undef
  $felix_os_region                  = undef
  $felix_etcd_endpoints             = 'http://127.0.0.1:23790',
  $libvirt_service_default          = 'libvirtd'
#  $manage_packages                  = false
#  $manage_repo                      = false
#  $manage_epel                      = false
  $neutron_service_default          = 'neutron-server'
  $reflector_bird_template          = 'calico/reflector/bird.conf.erb'
  $reflector_bird6_template         = 'calico/reflector/bird6.conf.erb'
  $reflector_client_template        = 'calico/reflector/client.erb'
  $reflector_manage_bird_config     = true
  $reflector_manage_clients         = true
  $router_id                        = fact('ipaddress')
  $qemu_conf_default                = '/etc/libvirt/qemu.conf'
  case $::osfamily {
    'Debian' : {
      case $::operatingsystem {
        default: {
          $compute_metadata_service = $compute_metadata_service_default
          $compute_metadata_package = $compute_metadata_package_default
          $compute_package          = $compute_package_default
          $controller_package       = $controller_package_default
          $felix_service            = $felix_service_default
          $libvirt_service          = $libvirt_service_default
          $neutron_service          = $neutron_service_default
          $qemu_conf                = $qemu_conf_default
        }
      }
    }
    'RedHat' : {
      validate_re($::operatingsystemmajrelease, '^7$', 'A 7.x Red Hat based system is required.')
      $compute_metadata_service = $compute_metadata_service_default
      $compute_metadata_package = $compute_metadata_package_default
      $compute_package          = $compute_package_default
      $controller_package       = $controller_package_default
      $felix_service            = $felix_service_default
      $libvirt_service          = $libvirt_service_default
      $neutron_service          = $neutron_service_default
      $qemu_conf                = $qemu_conf_default
    }
    default: {
      validate_re($::osfamily, '^(Debian|RedHat)$', 'Debian or Red Hat based system required.')
    }
  }


}
