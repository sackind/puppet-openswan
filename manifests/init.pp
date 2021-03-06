# Class: openswan
#
# This module manages openswan
#
# Parameters
#
# [*nat_traversal*]
#	  enable NAT traversal support
#	  Default: no
#	  Valid values: no, yes
#
# [*virtual_private*]
#	  specify the networks that are allowed as subnet= for the remote client
#	  Valid values: %v4:a.b.c.d/mm, %v4!:a.b.c.d/mm, %v6:aaaa::bbbb:cccc:dddd:eeee/mm
#
# [*protostack*]
#	  define which protocol stack is going to be used
#	  Valid values: auto, klips, netkey, mast
#
# [*uniqueids*]
#	  Default: yes
#	  Valid values: yes, no
#
# [*connections_dir*]
#   Connections files folder (*.conf)
#   Default: /etc/ipsec.d/connection 
#
# [*secretss_dir*]
#   secrets files folder (*.secrets)
#   Default: /etc/ipsec.d/connection
# 
#
# Requires: see Modulefile
#
# Sample Usage:
#
# class { 'openswan': }
#
# === Authors
#
# Ayoub Elhamdani <a.elhamdani90@gmail.com>
#
class openswan (
  $ensure                   = 'present',
  $openswan_package         = $openswan::params::openswan_pkg,
  $openswan_service        = $openswan::params::service_name,
  $nat_traversal            = $openswan::params::nat_traversal,
  $virtual_private          = $openswan::params::virtual_private,
  $opportunistic_encryption = $openswan::params::opportunistic_encryption,
  $protostack               = $openswan::params::protostack,
  $uniqueids                = $openswan::params::uniqueids,
  $ipsec_conf               = $openswan::params::ipsec_conf,
  $ipsec_secrets_conf       = $openswan::params::ipsec_secrets_conf,
  $connections_dir          = $openswan::params::connections_dir,
  $secrets_dir              = $openswan::params::secrets_dir
)inherits openswan::params{
  validate_re($ensure, ['present', 'absent'], "${ensure} is not a valid value for ensure attribute")
  validate_re($nat_traversal, ['yes', 'no'], 'valid values are : yes or no')
  validate_re($protostack, ['auto', 'klips', 'netkey', 'mast'], 'valid values are : auto, klips, netkey, mast')
  validate_re($uniqueids, ['yes', 'no'], 'valid values are : yes or no')

  if $ensure == 'present' {
    contain openswan::install
    contain openswan::config
    contain openswan::service

    Class['openswan::install'] ->
    Class['openswan::config'] ~>
    Class['openswan::service']

  }
  else {
    contain openswan::install
  }

}
