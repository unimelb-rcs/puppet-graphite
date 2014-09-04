define graphite::ini_setting ($setting, $value, $section)
{
  if ($value != undef) {
    ini_setting {"carbon_${name}":
      ensure  => present,
      path    => '/etc/carbon/carbon.conf',
      section => $section,
      setting => upcase($name),
      value   => $value,
    }
  }
}

