define graphite::carbon::aggregator::ini_setting ($value)
{
  if defined(Service['carbon-aggregator']) {
    $notify = Service['carbon-aggregator']
  }

  if ($value != undef) {
    ini_setting {"carbon_aggregator_${name}":
      ensure  => present,
      path    => '/etc/carbon/carbon.conf',
      section => 'aggregator',
      setting => upcase($name),
      value   => $value,
      notify  => $notify,
      require => Package[$graphite::params::package_carbon],
    }
  }
}
