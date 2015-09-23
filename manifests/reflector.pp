# == Class: calico::reflector
#
class calico::reflector (
  $config_template = undef,
  $manage_config   = true,
  $manage_clients  = true,
  $client_defaults = {},
  $client_template = undef,
  $clients         = {},
) {

  if $manage_config {
    file { 

    }

  }



}
