# Settings
BOX = "generic/ubuntu1804"

LIBVIRT_CPU = 2
LIBVIRT_MEM = 3000

$script = <<-SCRIPT
cat > /etc/apt/sources.list <<EOF
###### Ubuntu Main Repos
deb http://it.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse

###### Ubuntu Update Repos
deb http://it.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://it.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://it.archive.ubuntu.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://it.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

sed -ie '/^DNS/d' /etc/systemd/resolved.conf
echo 'DNS = 1.1.1.1 7.7.7.7 8.8.8.8' >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
SCRIPT

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

  # Replace Ubuntu repos
  config.vm.provision "shell",
    privileged: true,
    inline: $script
end
