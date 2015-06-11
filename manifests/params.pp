#
# == Class: patterndb::params
#
# Defines some variables based on the operating system
#
class patterndb::params {

  case $::osfamily {
    'RedHat': {
      $syslog_ng_package_name = 'syslog-ng'
      $default_syslog_package_name = 'rsyslog'
    }
    'Debian': {
      $syslog_ng_package_name = 'syslog-ng'
      $default_syslog_package_name = 'rsyslog'
    }
    default: {
      fail("Unsupported operating system ${::osfamily}")
    }
  }
}
