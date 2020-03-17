# Settings
BOX = "generic/ubuntu1804"

LIBVIRT_CPU = 2
LIBVIRT_MEM = 3000

# Logic
Vagrant.configure("2") do |config|

  # Generic configuration
  config.vm.box = BOX
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Assign libvirt
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = LIBVIRT_CPU
    libvirt.memory = LIBVIRT_MEM
    libvirt.machine_virtual_size = 64
  end

  # Forwarded ports
  config.vm.network "forwarded_port", guest: 8080, host: 8080

end
