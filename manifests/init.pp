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

# == Class: logstash
#
# This class is able to activate and configure logstash-web
#
#
# === Parameters
#
# [*nginx_install*]
#   Use Nginx webserver instead of the java webserver
#
# [*nginx_manage_config*]
#   Manage the Nginx logstahweb config with this module
#
# [*nginx_hostname*]
#   What is the hostname for your logstash-web website, stadard is your server fqdn.
#
# [*nginx_passwd_file*]
#   Define a file if you want to setup basic authentication
#
# [*nginx_ssl*]
#   Activate SSL on your webserver
#
# [*nginx_ssl_certificate*]
#   SSL certificate file
#
# [*nginx_ssl_certificate_key*]
#   SSL certificate key
#
# === Examples
#
# * Installation, make sure service is running and will start at boot time:
#     class { 'logstash-web': }
#
# * Advanced installation of logstash-web with Nginx
#     class {'logstashweb':
#       nginx_manage_config       => true,
#       nginx_install             => true,
#       nginx_passwd_file         => '/etc/nginx/passwd',
#       nginx_ssl                 => true,
#       nginx_ssl_certificate     => '/etc/nginx/ssl/certificate.crt',
#       nginx_ssl_certificate_key => '/etc/nginx/ssl/certificate.key',
#     }
#
class logstashweb(
  $nginx_install              = $logstashweb::params::nginx_install,
  $nginx_manage_config        = $logstashweb::params::nginx_manage_config,
  $nginx_hostname             = $logstashweb::params::nginx_hostname,
  $nginx_passwd_file          = undef,
  $nginx_ssl                  = $logstashweb::params::nginx_ssl,
  $nginx_ssl_certificate      = false,
  $nginx_ssl_certificate_key  = false,
  $dhparam_file               = undef,

) inherits logstashweb::params {

  if ($nginx_ssl == true) {
    validate_string($nginx_ssl_certificate)
    validate_string($nginx_ssl_certificate_key)
  }

  if $nginx_ssl == true {
    $nginx_port = 443
    $nginx_protocol = 'https'
  } else {
    $nginx_port = 80
    $nginx_protocol = 'http'
  }

  class { 'logstashweb::config': }
  class { 'logstashweb::service': }

  ## Install nginx if needed
  if $nginx_install == true {
    # Install nginx
    class { 'nginx': }
    Class['nginx'] -> Class['logstashweb::config']
  }
}
