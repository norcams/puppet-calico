# == Class: calico::bgp_rr
#
class calico::reflector (
  $manage_bird = true,
  $peers       = {},
) inherits calico::params {

  if $manage_bird {
    include 'calico::bird'
    calico::reflector:peer { $calico::reflector::peers: }
  }

}
