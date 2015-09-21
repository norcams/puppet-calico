#
# Configuration values documented at
# http://docs.projectcalico.org/en/latest/redhat-opens-install.html
#
class calico::compute::qemu {
  include 'calico::params'

  augeas { 'qemu_cgroup_device_acl':
    context   => "/files${qemu_conf}/",
    changes => [
      "set cgroup_device_acl/1 /dev/null",
      "set cgroup_device_acl/2 /dev/full",
      "set cgroup_device_acl/3 /dev/zero",
      "set cgroup_device_acl/4 /dev/random",
      "set cgroup_device_acl/5 /dev/urandom",
      "set cgroup_device_acl/6 /dev/ptmx",
      "set cgroup_device_acl/7 /dev/kvm",
      "set cgroup_device_acl/8 /dev/kqemu",
      "set cgroup_device_acl/9 /dev/rtc",
      "set cgroup_device_acl/10 /dev/hpet",
      "set cgroup_device_acl/11 /dev/net/tun",
    ],
    onlyif  => "get /files${qemu_conf}/cgroup_device_acl/11 != '/dev/net/tun'",
    notify  => Service[$libvirt_service]
  }

  augeas { 'qemu_settings':
    context   => "/files${qemu_conf}/",
    changes => [
      "set clear_emulator_capabilities 0",
      "set user root",
      "set group root",
    ],
    notify  => Service[$libvirt_service]
  }

}
