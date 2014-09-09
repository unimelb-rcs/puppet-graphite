class graphite::apache (
  $service = 'apache2'
) {

  file { '/etc/apache2/sites-available/graphite.conf':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/etc/graphite-web/apache.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$graphite::params::package_web],
    notify  => Service[$service],
  }

  file { '/etc/apache2/sites-enabled/graphite.conf':
    ensure  => link,
    target  => '/etc/apache2/sites-available/graphite.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [Package[$graphite::params::package_web],
                File['/etc/apache2/sites-available/graphite.conf']],
    notify  => Service[$service],
  }

}
