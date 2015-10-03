# == Class: calico
#
class calico::controller (
) {

  neutron_config {
    'calico/etcd_host': value => $calico::controller_etcd_host;
    'calico/etcd_port': value => $calico::controller_etcd_port;
  }

  package { $calico::controller_package:
    ensure => installed,
  }

  # Install the package, then notify the neutron service
  Package[$calico::controller_package] ~>
  Service[$calico::neutron_service]

}
