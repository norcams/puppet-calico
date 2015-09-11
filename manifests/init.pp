# == Class: calico
#
class calico (
  $compute     = false,
  $controller  = false,
  $manage_repo = false,
) inherits calico::params {

  validate_bool($compute)
  validate_bool($controller)

  if $compute {
    contain ::calico::compute
  }

  if $controller {
    contain ::calico::controller
  }

}
