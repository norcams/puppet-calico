# == Class: calico::params
#
# Default parameter values
#
class calico::params {
  $ensure                           = present
  $enable_ipv4                      = true
  $enable_ipv6                      = true
  $manage_packages                  = false
  $manage_repo                      = false
  $manage_epel                      = false
  $compute_metadata_service_default = 'openstack-nova-metadata-api'
  $compute_metadata_package_default = 'openstack-nova-api'
  $compute_package_default          = 'calico-compute'
  $compute_service_default          = 'calico-felix'
  $controller_package_default       = 'calico-control'
  $controller_service_default       = 'neutron-server'
  $libvirt_service_default          = 'libvirtd'
  $qemu_conf_default                = '/etc/libvirt/qemu.conf'
  case $::osfamily {
    'Debian' : {
      case $::operatingsystem {
        default: {
          $compute_metadata_service = $compute_metadata_service_default
          $compute_metadata_package = $compute_metadata_package_default
          $compute_package          = $compute_package_default
          $compute_service          = $compute_service_default
          $controller_package       = $controller_package_default
          $controller_service       = $controller_service_default
          $libvirt_service          = $libvirt_service_default
          $qemu_conf                = $qemu_conf_default
        }
      }
    }
    'RedHat' : {
      validate_re($::operatingsystemmajrelease, '^7$', 'A 7.x Red Hat based system is required.')
      $compute_metadata_service = $compute_metadata_service_default
      $compute_metadata_package = $compute_metadata_package_default
      $compute_package          = $compute_package_default
      $compute_service          = $compute_service_default
      $controller_package       = $controller_package_default
      $controller_service       = $controller_service_default
      $libvirt_service          = $libvirt_service_default
      $qemu_conf                = $qemu_conf_default
    }
    default: {
      validate_re($::osfamily, '^(Debian|RedHat|Archlinux)$', 'Debian or Red Hat based system required.')
    }
  }


}
