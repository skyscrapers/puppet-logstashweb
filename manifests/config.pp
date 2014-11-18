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

# == Class logstashweb::config
#
# This class is called from logstashweb
#
class logstashweb::config {

  #### Configuration
  if ( $logstashweb::nginx_manage_config == true ) {
    file {
      '/etc/nginx/sites-available/logstashweb.conf':
        ensure   => file,
        content  => template('logstashweb/etc/nginx/logstashweb.conf.erb'),
        mode     => '0644',
        owner    => root,
        group    => root;

      '/opt/logstash/vendor/kibana/config.js':
        ensure   => file,
        content  => template('logstashweb/opt/logstash/vendor/kibana/config.js.erb'),
        mode     => '0664',
        owner    => logstash,
        group    => logstash;

      '/etc/nginx/sites-enabled/logstashweb.conf':
        ensure  => target,
        target  => '/etc/nginx/sites-available/logstashweb.conf',
        require => File['/etc/nginx/sites-available/logstashweb.conf'],
        notify  => Exec['restart-nginx'];
    }
  }
}
