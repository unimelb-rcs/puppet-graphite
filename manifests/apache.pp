class graphite::apache (
  $service = 'apache2'
) {

  file { '/etc/apache2/sites-available/graphite':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/etc/graphite-web/apache.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$graphite::params::package_web],
    notify  => Service[$service],
  }

  file { '/etc/apache2/sites-enabled/graphite':
    ensure  => link,
    source  => '/etc/apache2/sites-available/graphite',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$graphite::params::package_web],
    notify  => Service[$service],
  }

}
