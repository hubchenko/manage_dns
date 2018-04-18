
## manage_dns_pm
A puppet module that the manages dynamic DNS registeration using questDNS update


#### Prerequisites
* Linux Ubuntu 14.04
* Puppet 3.7.4 or greater


#### Development Server Installation

Clone the repository
```bash
git clone https://github.intel.com/HostingSDI/manage_dns_pm.git manage_dns
mv manage_dns_pm/ manage_dns/ 
cd manage_dns
```

Install packages and dependencies
```bash
chmod +x build.sh
sudo ./build.sh
```

Execute test task to lint and syntax check all modules
```bash
sudo rake test
```
