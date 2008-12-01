# manifests/defines/vhost_varieties.pp

### sepcific vhosts varieties
#
# - apache::vhost::static
# - apache::vhost::php
# - apache::vhost::cgi TODO
# - apache::vhost::modperl TODO
# - apache::vhost::modpython TODO
# - apache::vhost::modrails TODO

# vhost_mode: which option is choosed to deploy the vhost
#   - template: generate it from a template (default)
#   - file: deploy a vhost file (apache::vhost::file will be called directly)
#   
define apache::vhost::static(
    $domain = 'absent',
    $domainalias = 'absent',
    $path = 'absent',
    $owner = root,
    $group = 0,
    $documentroot_owner = apache,
    $documentroot_group = 0,
    $documentroot_mode = 0750,
    $allow_override = 'None',
    $options = 'absent',
    $additional_options = 'absent',
    $ssl_mode = 'false',
    $vhost_mode = 'template',
    $vhost_source = 'absent',
    $vhost_destination = 'absent',
    $htpasswd_file = 'absent',
    $htpasswd_path = 'absent'
){
    # create webdir
    apache::vhost::webdir{$name:
        path => $path,
        owner => $owner,
        group => $group,
        documentroot_owner => $documentroot_owner,
        documentroot_group => $documentroot_group,
        documentroot_mode => $documentroot_mode,
    }

    # create vhost configuration file
    apache::vhost{$name:
        path => $path,
        template_mode => 'static',
        vhost_mode => $vhost_mode,
        vhost_source => $vhost_source,
        vhost_destination => $vhost_destination,
        domain => $domain,
        domainalias => $domainalias,
        allow_override => $allow_override,
        options => $options,
        additional_options => $additional_options,
        ssl_mode => $ssl_mode,
        htpasswd_file => $htpasswd_file,
        htpasswd_path => $htpasswd_path,
        mod_security => 'false',
    }
}

define apache::vhost::php::standard(
    $domain = 'absent',
    $domainalias = 'absent',
    $path = 'absent',
    $owner = root,
    $group = 0,
    $documentroot_owner = apache,
    $documentroot_group = 0,
    $documentroot_mode = 0750,
    $allow_override = 'None',
    $upload_tmp_dir = 'absent',
    $session_save_path = 'absent',
    $options = 'absent',
    $additional_options = 'absent',
    $mod_security = 'true',
    $vhost_mode = 'template',
    $vhost_source = 'absent',
    $vhost_destination = 'absent',
    $htpasswd_file = 'absent',
    $htpasswd_path = 'absent'
){
    # php upload_tmp_dir
    case $upload_tmp_dir {
        'absent': {
            include apache::defaultphpdirs
            $real_upload_tmp_dir = "/var/www/upload_tmp_dir/$name"
        }
        default: { $real_upload_tmp_dir = $upload_tmp_dir }
    }
    file{$real_upload_tmp_dir:
        ensure => directory,
        owner => $documentroot_owner, 
        group => $documentroot_group, 
        mode => $documentroot_mode;
    }

    # php session_save_path
    case $session_save_path {
        'absent': {
            include apache::defaultphpdirs
            $real_session_save_path = "/var/www/session.save_path/$name"
        }
        default: { $real_session_save_path = $session_save_path }
    }
    file{"$real_session_save_path":
        ensure => directory,
        owner => $documentroot_owner, 
        group => $documentroot_group, 
        mode => $documentroot_mode;
    }

    # create webdir
    apache::vhost::webdir{$name:
        path => $path,
        owner => $owner,
        group => $group,
        documentroot_owner => $documentroot_owner,
        documentroot_group => $documentroot_group,
        documentroot_mode => $documentroot_mode,
    }

    # create vhost configuration file
    apache::vhost{$name:
        path => $path,
        template_mode => 'php',
        vhost_mode => $vhost_mode,
        vhost_source => $vhost_source,
        vhost_destination => $vhost_destination,
        domain => $domain,
        domainalias => $domainalias,
        allow_override => $allow_override,
        options => $options,
        additional_options => $additional_options,
        php_upload_tmp_dir => $real_upload_tmp_dir,
        php_session_save_path => $real_session_save_path,
        ssl_mode => $ssl_mode,
        htpasswd_file => $htpasswd_file,
        htpasswd_path => $htpasswd_path,
        mod_security => $mod_security,
    }
}

define apache::vhost::perl(
    $domain = 'absent',
    $domainalias = 'absent',
    $path = 'absent',
    $owner = root,
    $group = 0,
    $documentroot_owner = apache,
    $documentroot_group = 0,
    $documentroot_mode = 0750,
    $allow_override = 'None',
    $cgi_binpath = 'absent',
    $options = 'absent',
    $additional_options = 'absent',
    $mod_security = 'true',
    $vhost_mode = 'template',
    $vhost_source = 'absent',
    $vhost_destination = 'absent',
    $htpasswd_file = 'absent',
    $htpasswd_path = 'absent'
){
    # cgi_bin path
    case $cgi_binpath {
        'absent': {
            $real_cgi_binpath = "${path}/cgi-bin" }
        }
        default: { $real_cgi_binpath = $cgi_binpath
    }
    file{$real_cgi_binpath:
        ensure => directory,
        owner => $documentroot_owner,
        group => $documentroot_group,
        mode => $documentroot_mode;
    }

    # create webdir
    apache::vhost::webdir{$name:
        path => $path,
        owner => $owner,
        group => $group,
        documentroot_owner => $documentroot_owner,
        documentroot_group => $documentroot_group,
        documentroot_mode => $documentroot_mode,
    }

    # create vhost configuration file
    apache::vhost{$name:
        path => $path,
        template_mode => 'perl',
        vhost_mode => $vhost_mode,
        vhost_source => $vhost_source,
        vhost_destination => $vhost_destination,
        domain => $domain,
        domainalias => $domainalias,
        allow_override => $allow_override,
        options => $options,
        additional_options => $additional_options,
        cgi_binpath => $real_cgi_binpath,
        ssl_mode => $ssl_mode,
        htpasswd_file => $htpasswd_file,
        htpasswd_path => $htpasswd_path,
        mod_security => $mod_security,
    }

}
