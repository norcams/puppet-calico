# == Class: calico
#
class calico (
  $compute     = false,
  $controller  = false,
  $enable_ipv4 = $calico::params::enable_ipv4,
  $enable_ipv6 = $calico::params::enable_ipv6,
  $manage_repo = false,
  $reflector   = false,
) inherits calico::params {

  validate_bool($compute)
  validate_bool($controller)
  validate_bool($reflector)
  if $compute and $controller {
    fail("Enabling compute and controller on a single node is not supported (yet?)")
  }

  if $compute {
    contain 'calico::compute'
  }

  if $controller {
    contain 'calico::controller'
  }

  if $reflector {
    contain 'calico::reflector'
  }

}
