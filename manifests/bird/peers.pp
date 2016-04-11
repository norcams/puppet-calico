#
define calico::bird::peers(
  $peer_defaults,
  $peer_template,
  $peers,
) {
  validate_hash($peer_defaults)
  validate_hash($peers)

  $peer = deep_merge($peer_defaults, $peers[$name])

  if has_key($peer, 'peer_ipv4') {
    calico::bird::peer { "${name}_ipv4":
      protocol => 'ipv4',
      peer_ip  => $peer['peer_ipv4'],
      peer_as  => $peer['peer_as'],
      local_as => $peer['local_as'],
      local_ip => $peer['local_ipv4'],
      local_pref => $peer['local_pref'],
      template => $peer_template,
    }
  }

  if has_key($peer, 'peer_ipv6') {
    calico::bird::peer { "${name}_ipv6":
      protocol => 'ipv6',
      peer_ip  => $peer['peer_ipv6'],
      peer_as  => $peer['peer_as'],
      local_as => $peer['local_as'],
      local_ip => $peer['local_ipv6'],
      template => $peer_template,
    }
  }

}
