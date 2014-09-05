# == Class: graphite::carbon::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'graphite::carbon::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::carbon::relay::config {

  #### Configuration

  file_fragment { "carbon_relay_header_${::fqdn}":
    tag     => "carbon_relay_rules_${::fqdn}",
    content => template("${module_name}/etc/carbon/relay-rules-header.erb"),
    order   => 01
  }

  file_concat { '/etc/carbon/relay-rules.conf':
    tag     => "carbon_relay_rules_${::fqdn}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/carbon']
  }

}
