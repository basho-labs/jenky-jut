# -*- mode: ruby -*-
# vi: set ft=ruby :

# Build box for Erlang Riak Mesos Framework (ERMF)

# Install these plugins
# vagrant plugin install vagrant-cachier

def set_vm_box
  # TODO: add debian 7 "wheezy", 8 "jessie"
  $target_vm=(ENV['TARGET_VM'] || 'ubuntu').downcase

  case $target_vm
  when 'ubuntu'
    $target_vm_variant=(ENV['TARGET_VM_VARIANT'] || 'trusty').downcase
  when 'centos'
    $target_vm_variant=(ENV['TARGET_VM_VARIANT'] || '6').downcase
  end

  case $target_vm
  when 'ubuntu'
    case $target_vm_variant
    when 'precise', '12.04'
      $vm_box = 'bento/ubuntu-12.04'
    when 'trusty', '14.04'
      $vm_box = 'bento/ubuntu-14.04'
    else
      raise "Invalid TARGET_VM, TARGET_VM_VARIANT combination, #{TARGET_VM} supports only { precise | trusty }"
    end
  when 'centos'
    case $target_vm_variant
    when '6'
      $vm_box = 'bento/centos-6.7'
    when '7'
      $vm_box = 'bento/centos-7.1'
    else
      raise "Invalid TARGET_VM, TARGET_VM_VARIANT combination, #{TARGET_VM} supports only { 6 | 7 }"
    end
  else
    raise "TARGET_VM, TARGET_VM_VARIANT must be specified."
  end
end
set_vm_box

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = $vm_box
  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--memory", 8000,  "--cpus", "4"]
  end

  config.vm.synced_folder ".", "/hostfiles"
  config.vm.synced_folder "downloads", "/downloads"
  config.vm.provision 'file', source: "~/.set_aws_creds.sh", destination: ".set_aws_creds.sh"
  config.vm.provision 'shell', path: "#{$target_vm}/install.sh", run: 'once'

  config.vm.network 'forwarded_port', guest: 8080, host: 18080

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
  end
end
