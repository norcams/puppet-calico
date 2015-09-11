# == Class: calico
#
class calico (
  $enable_compute    = false,
  $enable_controller = false,
  $manage_repo       = false,
) inherits calico::params {

  validate_bool($enable_compute)
  validate_bool($enable_controller)

  if $enable_compute {
    include ::calico::compute
  }

  if $enable_controller {
    include ::calico::controller
  }

  contain 'calico::compute'
  contain 'calico::controller'

}
