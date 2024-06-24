# == Class: calico
#
class calico::controller (
  $controller_package        = $calico::controller_package,
  $controller_package_ensure = $calico::controller_package_ensure,
  $neutron_service           = 'httpd',
  $etcd_host                 = $calico::controller_etcd_host,
  $etcd_port                 = $calico::controller_etcd_port,
) {

  # Add calico-specific config to neutron.conf
  neutron_config {
    'calico/etcd_host': value => $etcd_host;
    'calico/etcd_port': value => $etcd_port;
  }

  package { $controller_package:
    ensure => $controller_package_ensure,
  }

  # Install the package, then notify the neutron service
  Package[$calico::controller_package] ~>
  Service[$neutron_service]
}
