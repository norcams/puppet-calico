#
define calico::bird::peers(
  $peer_defaults,
  $peer_template,
  $peers,
) {
  validate_hash($peer_defaults)
  validate_hash($peers)

  $peer = $peers[$name]

  if has_key($peer, 'ipv4') {
    calico::bird::peer { "${name}_ipv4":
      protocol => 'ipv4',
      peer_ip  => $peer['ipv4'],
      peer_as  => $peer['peer_as'],
      local_as => $peer['local_as'],
      local_ip => $peer['local_ip'],
      template => $peer_template,
    }
  }

  if has_key($peer, 'ipv6') {
    calico::bird::peer { "${name}_ipv6":
      protocol => 'ipv6',
      peer_ip  => $peer['ipv6'],
      peer_as  => $peer['peer_as'],
      local_as => $peer['local_as'],
      local_ip => $peer['local_ip'],
      template => $peer_template,
    }
  }

}
