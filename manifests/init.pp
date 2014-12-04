# == Class: heroku
#
# Install the Heroku Client.
#
class heroku (
  $heroku_client_url  = $heroku::params::client_url,
  $install_parent_dir = $heroku::params::install_parent_dir,
  $artifact_dir       = $heroku::params::artifact_dir,
  $link_dir           = $heroku::params::link_dir,
  $shell              = $heroku::params::shell
) inherits heroku::params {

  file { $artifact_dir:
    ensure => directory,
    before => Exec['download_heroku_toolbelt'],
  }

  exec { 'download_heroku_toolbelt':
    command => "curl -o ${artifact_dir}/heroku-client.tgz ${heroku_client_url}",
    creates => "${artifact_dir}/heroku-client.tgz",
    unless  => 'which heroku',
    require => Package['curl'],
    before  => Exec['untar_heroku_toolbelt'],
  }

  exec { 'untar_heroku_toolbelt':
    command => "/bin/tar xfz ${artifact_dir}/heroku-client.tgz",
    cwd     => $install_parent_dir,
    creates => "${install_parent_dir}/heroku-client",
    before  => File[$link_dir],
  }

  file { $link_dir:
    ensure => link,
    target => "${install_parent_dir}/heroku-client",
  }

  exec { 'add_heroku_bin_to_path':
    command => "echo 'export PATH=\"${link_dir}/bin:\$PATH\"' >> /etc/${shell}rc",
    unless  => "grep -q 'export PATH=\"${link_dir}/bin:\$PATH\"' /etc/${shell}rc",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File[$link_dir],
  }

}
