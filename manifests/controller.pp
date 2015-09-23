# == Class: calico
#
class calico::controller (
) {

  package { $calico::controller_package:
    ensure => installed,
  }

  # Install the package, then notify the neutron service
  Package[$calico::controller_package] ~>
  Service[$calico::neutron_service]

}
