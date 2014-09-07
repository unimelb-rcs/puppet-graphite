define graphite::carbon::aggregator::ini_setting ($value)
{
  if ($value != undef) {
    ini_setting {"carbon_aggregator_${name}":
      ensure  => present,
      path    => '/etc/carbon/carbon.conf',
      section => 'aggregator',
      setting => upcase($name),
      value   => $value,
      notify  => Service['carbon-aggregator'],
    }
  }
}

