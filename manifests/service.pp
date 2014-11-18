##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2014 - http://skyscrape.rs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# == Class logstashweb::service
#
# This class is meant to be called from logstashweb
# It ensure the service is running
#
class logstashweb::service {
  ### Service management

  file { '/etc/init/logstash-web.conf':
    ensure => 'absent'
  }

  # action
  if ( $logstashweb::nginx_manage_config != true ) {
    service { 'logstash-web':
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      provider   => [ 'init' ],
      require    => File['/etc/init/logstash-web.conf']
    }
  }
}
