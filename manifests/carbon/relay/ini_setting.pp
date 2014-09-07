define graphite::carbon::relay::ini_setting ($value)
{
  if ($value != undef) {
    ini_setting {"carbon_relay_${name}":
      ensure  => present,
      path    => '/etc/carbon/carbon.conf',
      section => 'relay',
      setting => upcase($name),
      value   => $value,
      notify  => Service['carbon-relay'],
    }
  }
}

