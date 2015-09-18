# == Class: calico
#
class calico::controller (
) inherits calico::params {

  package { $controller_package:
    ensure => $ensure,
  }

  # Install the package, then notify the service
  Package[$controller_package] ~>
  Service[$controller_service]

}
