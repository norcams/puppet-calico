#
define calico::compute::peer(
  ensure       = 'present'
  ip_protocol  = undef,
  local_as     = undef,
  neighbour_ip = undef,
  neighbour_as = undef,
) {
  if $ensure == 'present' {
    file { 
    
    }
  } else {
    file {

    }
  }

}
