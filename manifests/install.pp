#
# == Class: patterndb::install
#
# Ensure that the default syslog is uninstalled and that syslog-ng is installed.
#
class patterndb::install (
    $package_name
) inherits patterndb::params
{
  if is_string($package_name) {
    $real_package_name = $package_name
  } else {
    $real_package_name = $::patterndb::params::syslog_ng_package_name
  }

  package { $::patterndb::params::default_syslog_package_name:
    ensure => absent,
  }

  package { $real_package_name:
    ensure => installed,
    require => Package[$::patterndb::params::default_syslog_package_name],
  }
}
