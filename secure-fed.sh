#!/bin/bash

apt_update() {
  # Update package list
  dnf update
}

install_fail2ban() {
  # Install fail2ban
  dnf install fail2ban -y
  systemctl enable fail2ban
}

configure_kernel() {
  # Configure Kernel
  echo "net.ipv4.tcp_syncookies= 1
net.ipv4.conf.all.accept_source_route= 0
net.ipv6.conf.all.accept_source_route= 0
net.ipv6.conf.all.forwarding= 0
net.ipv6.conf.all.accept_ra= 0
net.ipv4.conf.default.accept_source_route= 0
net.ipv6.conf.default.accept_source_route= 0
net.ipv4.conf.all.accept_redirects= 0
net.ipv6.conf.all.accept_redirects= 0
net.ipv4.conf.default.accept_redirects= 0
net.ipv6.conf.default.accept_redirects= 0
net.ipv4.conf.all.secure_redirects= 1
net.ipv4.conf.default.secure_redirects= 1
net.ipv4.conf.all.send_redirects= 0
net.ipv4.conf.default.send_redirects= 0
net.ipv4.conf.all.rp_filter= 1
net.ipv4.conf.default.rp_filter= 1
net.ipv4.icmp_echo_ignore_broadcasts= 1
net.ipv4.icmp_ignore_bogus_error_responses= 1
net.ipv4.icmp_echo_ignore_all= 0
net.ipv4.conf.all.log_martians= 1
net.ipv4.conf.default.log_martians= 1
net.ipv4.tcp_rfc1337= 1
kernel.randomize_va_space= 2
fs.protected_hardlinks= 1
fs.protected_symlinks= 1
kernel.perf_event_paranoid= 2
kernel.core_uses_pid= 1
kernel.kptr_restrict= 2
kernel.sysrq= 0
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=0
net.ipv4.conf.all.force_igmp_version=2
kernel.randomize_va_space=1
kernel.printk=4
kernel.panic=10
kernel.sysrq=0
kernel.shmall=4194304
kernel.core_uses_pid=2
kernel.msgmnb=65536
kernel.msgmax=65536
vm.swappiness=30
vm.dirty_ratio=70
vm.dirty_background_ratio=5
fs.file-max=2097152
net.core.netdev_max_backlog=262144
net.core.rmem_default=31457280
net.core.rmem_max=67108864
net.core.wmem_default=31457280
net.core.wmem_max=67108864
net.core.somaxconn=65535
net.core.optmem_max=25165824
net.ipv4.neigh.default.gc_thresh1=4096
net.ipv4.neigh.default.gc_thresh2=8192
net.ipv4.neigh.default.gc_thresh3=16384
net.ipv4.neigh.default.gc_interval=5
net.ipv4.neigh.default.gc_stale_time=360
net.ipv6.neigh.default.gc_thresh1=4096
net.ipv6.neigh.default.gc_thresh2=8192
net.ipv6.neigh.default.gc_thresh3=16384
net.ipv6.neigh.default.gc_interval=5
net.ipv6.neigh.default.gc_stale_time=360
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.ip_no_pmtu_disc=1
net.ipv4.route.flush=1
net.ipv4.route.max_size=8048576
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.tcp_mem=262144
net.ipv4.udp_mem=262144
net.ipv4.tcp_rmem=33554432
net.ipv4.udp_rmem_min=16384
net.ipv4.tcp_wmem=33554432
net.ipv4.udp_wmem_min=16384
net.ipv4.tcp_max_tw_buckets=1440000
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_max_orphans=400000
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_synack_retries=1
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_max_syn_backlog=16384
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_fack=1
net.ipv4.tcp_ecn=2
net.ipv4.tcp_fin_timeout=1600
net.ipv4.tcp_keepalive_time=3600
net.ipv4.tcp_keepalive_intvl=3600
net.ipv4.tcp_keepalive_probes=1600
net.ipv4.tcp_no_metrics_save=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.all.rp_filter=1" > /etc/sysctl.d/80-feed.conf
  sysctl --system
}

configure_auditd() {
  # Install auditd
  dnf install auditd -y

  # Add config
  echo "
# Remove any existing rules
#-D

# Buffer Size
# Might need to be increased, depending on the load of your system.
-b 8192

# Failure Mode
# 0=Silent
# 1=printk, print failure message
# 2=panic, halt system
-f 1

# Audit the audit logs.
-w /var/log/audit/ -k auditlog

## Auditd configuration
## Modifications to audit configuration that occur while the audit (check your paths)
-w /etc/audit/ -p wa -k auditconfig
-w /etc/libaudit.conf -p wa -k auditconfig
-w /etc/audisp/ -p wa -k audispconfig

# Schedule jobs
-w /etc/cron.allow -p wa -k cron
-w /etc/cron.deny -p wa -k cron
-w /etc/cron.d/ -p wa -k cron
-w /etc/cron.daily/ -p wa -k cron
-w /etc/cron.hourly/ -p wa -k cron
-w /etc/cron.monthly/ -p wa -k cron
-w /etc/cron.weekly/ -p wa -k cron
-w /etc/crontab -p wa -k cron
-w /var/spool/cron/crontabs/ -k cron

## user, group, password databases
-w /etc/group -p wa -k etcgroup
-w /etc/passwd -p wa -k etcpasswd
-w /etc/gshadow -k etcgroup
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd

# Monitor usage of passwd command
-w /usr/bin/passwd -p x -k passwd_modification

# Monitor user/group tools
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification

# Login configuration and stored info
-w /etc/login.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login

# Network configuration
-w /etc/hosts -p wa -k hosts
-w /etc/network/ -p wa -k network

## system startup scripts
-w /etc/inittab -p wa -k init
-w /etc/init.d/ -p wa -k init
-w /etc/init/ -p wa -k init

# Library search paths
-w /etc/ld.so.conf -p wa -k libpath

# Kernel parameters and modules
-w /etc/sysctl.conf -p wa -k sysctl
-w /etc/modprobe.conf -p wa -k modprobe

# SSH configuration
-w /etc/ssh/sshd_config -k sshd

# Hostname
-a exit,always -F arch=b32 -S sethostname -k hostname
-a exit,always -F arch=b64 -S sethostname -k hostname

# Log all commands executed by root
-a exit,always -F arch=b64 -F euid=0 -S execve -k rootcmd
-a exit,always -F arch=b32 -F euid=0 -S execve -k rootcmd

## Capture all failures to access on critical elements
-a exit,always -F arch=b64 -S open -F dir=/etc -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/home -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/srv -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/local/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/var -F success=0 -k unauthedfileacess

## su/sudo
-w /bin/su -p x -k priv_esc
-w /usr/bin/sudo -p x -k priv_esc
-w /etc/sudoers -p rw -k priv_esc

# Poweroff/reboot tools
-w /sbin/halt -p x -k power
-w /sbin/poweroff -p x -k power
-w /sbin/reboot -p x -k power
-w /sbin/shutdown -p x -k power

# Make the configuration immutable
-e 2
" > /etc/audit/rules.d/audit.rules
  systemctl enable auditd.service
  service auditd restart
}

disable_core_dumps() {
  # Disable core dumps
  echo "* hard core 0" >> /etc/security/limits.conf
  echo "ProcessSizeMax=0
  Storage=none" >> /etc/systemd/coredump.conf
  echo "ulimit -c 0" >> /etc/profile
}

setup_aide() {
  # Setup aide
  aideinit
  mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
}

enable_process_accounting() {
  # Enable process accounting
  systemctl enable acct.service
  systemctl start acct.service
}

disable_uncommon_protocols() {
  echo "install sctp /bin/true
install dccp /bin/true
install rds /bin/true
install tipc /bin/true" >> /etc/modprobe.d/protocols.conf
}

change_root_permissions() {
 # Change /root permissions
  chmod 700 /root
}

run() {
  typeset -f "$1" | tail -n +2
    $1
}

run apt_update "Update and upgrade all packages"
run install_fail2ban "Install fail2ban"
run configure_kernel "Configure kernel"
run configure_auditd "Setup auditd"
run disable_core_dumps "Disable core dumps"
run setup_aide "Setup aide"
run enable_process_accounting "Enable process accounting"
run disable_uncommon_protocols "Disable uncommon protocols"
run change_root_permissions "Change root dir permissions"
run rm -f $0 "delete my self"

exit 0

