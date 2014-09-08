define graphite::carbon::cache::ini_setting ($value)
{
  if defined(Service['carbon-cache']) {
    $notify = Service['carbon-cache']
  }

  if ($value != undef) {
    ini_setting {"carbon_cache_${name}":
      ensure  => present,
      path    => '/etc/carbon/carbon.conf',
      section => 'cache',
      setting => upcase($name),
      value   => $value,
      notify  => $notify,
    }
  }
}
