class manage_dns
(
$register_dns       = True
    )

{

$source_file_path   = 'puppet:///modules/manage_dns/'
$questdns_file_path = '/tmp/quest-dnsupdate_1.3.4.194-1_amd64.deb'
$dns_bin_path       = '/opt/quest/sbin/dnsupdate'
$exec_command_path  = '/usr/local/sbin:/usr/local/sbin:/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin'
$dns_register_ip    = "`ip -f inet addr show dev eth0 | sed -n 's/^ *inet *\\([.0-9]*\\).*/\\1/p'`"

  if $register_dns {
    if $::operatingsystem == 'Ubuntu'{
      file {'quest_dns_deb':
        ensure  => file,
        source  => "${source_file_path}/quest-dnsupdate_1.3.4.194-1_amd64.deb",
        path    => $questdns_file_path,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        }

      package {'quest-dnsupdate':
        ensure      => installed,
        source      => $questdns_file_path,
        provider    => dpkg,
        require     => File['quest_dns_deb'],
        }

      exec {'dns_register':
        command     => "${dns_bin_path} -v -h ${$facts['fqdn']} ${dns_register_ip}",
        logoutput   => on_failure,
        path        => $exec_command_path,
        refreshonly => true,
        subscribe   => Package['quest-dnsupdate'],
        require     => Package['quest-dnsupdate'],
        }

      cron {'update_dns':
        ensure   => present,
        command  => "${dns_bin_path} -v -h ${$facts['fqdn']} ${dns_register_ip}",
        user     => 'root',
        hour     => '23',
        weekday  => '7',
        require  => Package['quest-dnsupdate'],
        }
    }
  }
}