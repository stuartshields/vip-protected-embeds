
class vip-protected-embeds (
  $path = '/vagrant/extensions/vip-protected-embeds'
) {
  file { "${$path}/local-config.php":
     content => template('vip-protected-embeds/local-config.php.erb'),
     owner   => 'www-data',
     group   => 'www-data',
     mode    => '0644',
  }

  if ! ( File['/vagrant/content'] ) {
    file { '/vagrant/content':
      ensure => 'directory',
    }
  }
  if ! ( File['/vagrant/content/plugins'] ) {
    file { '/vagrant/content/plugins':
      ensure => 'directory',
    }
  }

  exec { 'protected-embeds-install':
      command => 'git clone --recursive https://github.com/humanmade/protected-embeds.git /vagrant/content/plugins/protected-embeds',
      path    => [ '/usr/bin/', '/bin' ],
      require => Package[ 'git-core' ],
      onlyif  => 'test ! -d /vagrant/content/plugins/protected-embeds',
      timeout => 0
  }

  exec { 'protected-embeds-plugins-update':
      command => 'git --work-tree=/vagrant/content/plugins/protected-embeds --git-dir=/vagrant/content/plugins/protected-embeds/.git pull origin master',
      path    => [ '/usr/bin/', '/bin' ],
      require => [ Package[ 'git-core' ] ],
      onlyif  => 'test -d /vagrant/content/plugins/protected-embeds/.git',
      timeout => 0
 }


}
