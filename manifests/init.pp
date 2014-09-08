# == Class: graphite
#
# This class is able to install or remove graphite on a node.
# It manages the status of the related service.
#
# [Add description - What does this module do on a node?] FIXME/TODO
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and Puppet
#     does not care whether the service is running or not. For example, this may
#     be useful if a cluster management software is used to decide when to start
#     the service plus assuring it is running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed (see <tt>service.pp</tt> to check if this is the
#   case).
#
# [*version*]
#   String to set the specific version you want to install.
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in graphite::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation, make sure service is running and will be started at boot time:
#     class { 'graphite': }
#
# * Removal/decommissioning:
#     class { 'graphite':
#       ensure => 'absent',
#     }
#
# * Install everything but disable service(s) afterwards
#     class { 'graphite':
#       status => 'disabled',
#     }
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite(
  $ensure                                = $graphite::params::ensure,
  $autoupgrade                           = $graphite::params::autoupgrade,
  $status                                = $graphite::params::status,
  $version                               = false,
  $carbon_cache_enable                   = false,
  $carbon_relay_enable                   = false,
  $carbon_aggregator_enable              = false,
  $carbon_config_file                    = "puppet:///modules/${module_name}/etc/carbon/carbon.conf",
  $carbon_cache_init_file                = "puppet:///modules/${module_name}/etc/cache-init",
  $carbon_cache_default_file             = undef,
  $carbon_relay_init_file                = "puppet:///modules/${module_name}/etc/relay-init",
  $carbon_relay_default_file             = undef,
  $carbon_aggregator_init_file           = "puppet:///modules/${module_name}/etc/aggregator-init",
  $carbon_aggregator_default_file        = undef,

  $web_enable                            = false,
  $web_dashboard_config_file             = "puppet:///modules/${module_name}/etc/graphite-web/dashboard.conf",
  $web_secret_key                        = undef,

  $web_database_username                 = undef,
  $web_database_password                 = undef,
  $web_database_host                     = undef,
  $web_database_port                     = '',

  $web_carbonlink_hosts                  = undef,

  $cache_storage_dir                     = undef,
  $cache_local_data_dir                  = undef,
  $cache_max_cache_size                  = undef,
  $cache_max_updates_per_second          = undef,
  $cache_max_creates_per_minute          = undef,
  $cache_line_receiver_interface         = undef,
  $cache_line_receiver_port              = undef,
  $cache_udp_receiver_interface          = undef,
  $cache_udp_receiver_port               = undef,
  $cache_pickle_receiver_interface       = undef,
  $cache_pickle_receiver_port            = undef,
  $cache_query_interface                 = undef,

  $relay_line_receiver_interface         = undef,
  $relay_line_receiver_port              = undef,
  $relay_pickle_receiver_interface       = undef,
  $relay_pickle_receiver_port            = undef,
  $relay_destinations                    = undef,
  $relay_method                          = undef,
  $relay_replication_factor              = undef,
  $relay_max_queue_size                  = undef,
  $relay_use_flow_control                = undef,
  $relay_max_datapoints_per_message      = undef,

  $aggregator_line_receiver_interface    = undef,
  $aggregator_line_receiver_port         = undef,
  $aggregator_pickle_receiver_interface  = undef,
  $aggregator_pickle_receiver_port       = undef,
  $aggregator_destinations               = undef,
  $aggregator_forward_all                = undef,
  $aggregator_replication_factor         = undef,
  $aggregator_max_queue_size             = undef,
  $aggregator_use_flow_control           = undef,
  $aggregator_max_datapoints_per_message = undef,
  $aggregator_max_aggregation_intervals  = undef,


) inherits graphite::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status parameter value")
  }

  #### Manage actions

  class { 'graphite::carbon':
    cache_enable                          => $carbon_cache_enable,
    relay_enable                          => $carbon_relay_enable,
    aggregator_enable                     => $carbon_aggregator_enable,

    cache_storage_dir                     => $cache_storage_dir,
    cache_local_data_dir                  => $cache_local_data_dir,
    cache_max_cache_size                  => $cache_max_cache_size,
    cache_max_updates_per_second          => $cache_max_updates_per_second,
    cache_max_creates_per_minute          => $cache_max_creates_per_minute,
    cache_line_receiver_interface         => $cache_line_receiver_interface,
    cache_line_receiver_port              => $cache_line_receiver_port,
    cache_udp_receiver_interface          => $cache_udp_receiver_interface,
    cache_udp_receiver_port               => $cache_udp_receiver_port,
    cache_pickle_receiver_interface       => $cache_pickle_receiver_interface,
    cache_pickle_receiver_port            => $cache_pickle_receiver_port,
    cache_query_interface                 => $cache_query_interface,

    relay_line_receiver_interface         => $relay_line_receiver_interface,
    relay_line_receiver_port              => $relay_line_receiver_port,
    relay_pickle_receiver_interface       => $relay_pickle_receiver_interface,
    relay_pickle_receiver_port            => $relay_pickle_receiver_port,
    relay_destinations                    => $relay_destinations,
    relay_method                          => $relay_method,
    relay_replication_factor              => $relay_replication_factor,
    relay_max_queue_size                  => $relay_max_queue_size,
    relay_use_flow_control                => $relay_use_flow_control,
    relay_max_datapoints_per_message      => $relay_max_datapoints_per_message,

    aggregator_line_receiver_interface    => $aggregator_line_receiver_interface,
    aggregator_line_receiver_port         => $aggregator_line_receiver_port,
    aggregator_pickle_receiver_interface  => $aggregator_pickle_receiver_interface,
    aggregator_pickle_receiver_port       => $aggregator_pickle_receiver_port,
    aggregator_destinations               => $aggregator_destinations,
    aggregator_forward_all                => $aggregator_forward_all,
    aggregator_replication_factor         => $aggregator_replication_factor,
    aggregator_max_queue_size             => $aggregator_max_queue_size,
    aggregator_use_flow_control           => $aggregator_use_flow_control,
    aggregator_max_datapoints_per_message => $aggregator_max_datapoints_per_message,
    aggregator_max_aggregation_intervals  => $aggregator_max_aggregation_intervals,

  }
  class { 'graphite::web':
    enable                => $web_enable,
    dashboard_config_file => $web_dashboard_config_file,

    secret_key            => $web_secret_key,

    database_username     => $web_database_username,
    database_password     => $web_database_password,
    database_host         => $web_database_host,
    database_port         => $web_database_port,

    carbonlink_hosts      => $web_carbonlink_hosts,

  }

}
