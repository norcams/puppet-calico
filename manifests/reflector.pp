# == Class: calico::reflector
#
class calico::reflector (
  $bird_template           = $calico::reflector_bird_template,
  $manage_bird_config      = $calico::reflector_manage_bird_config,
  $manage_clients          = $calico::reflector_manage_clients,
  $client_defaults         = {},
  $client_template         = $calico::reflector_client_template,
  $clients                 = {},
  $router_id               = $calico::router_id,
) {

  validate_bool($manage_bird_config)
  validate_bool($manage_clients)
  validate_hash($client_defaults)
  validate_hash($clients)
  validate_ipv4_address($router_id)

  if $manage_bird_config {
    contain 'calico::bird'
  }

  if $manage_clients {
    contain 'calico::bird'
    $client_resources = keys($clients)
    calico::bird::peers { $client_resources:
      peer_defaults => $client_defaults,
      peer_template => $client_template,
      peers         => $clients,
    }
  }

}
