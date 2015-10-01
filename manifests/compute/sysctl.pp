#
class calico::compute::sysctl {

  sysctl::value { 'net.netfilter.nf_conntrack_max':
    value    => '1000000',
  }

}
