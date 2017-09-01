# == Define: nssm:install
#
# Define to create a Windows Service using 'nssm install'
#
# === Parameters
# [*ensure*]
#   present: create the service
#    absent: delete the service
#   Defaults to undefined
#
# [*program*]
#   exe to run as a service
#   Defaults to undefined
#
# [*service_name*]
#   name of the service to display in services.msc
#
# [*nssm_path*]
#   PATH to nssm exe
#   defaults to C:\Program Files\nssm-2.24\win64
#
define nssm::install (
  $ensure       = undef,
  $program      = undef,
  $service_name = $title,
  $nssm_path    = 'C:\Program Files\nssm-2.24\win64',
) {

  if $ensure == present {
    exec { 'install_service_name':
      command  => "nssm install '${service_name}' '${program}'",
      path     => $nssm_path,
      unless   => "& \"${nssm_path}\\nssm\" get '${service_name}' Name",
      provider => powershell,
    }
  }

  if $ensure == absent {
    exec { 'remove_service_name':
      command  => "nssm remove '${service_name}' confirm",
      path     => $nssm_path,
      onlyif   => "& \"${nssm_path}\\nssm\" get '${service_name}' Name",
      provider => powershell,
    }
  }

}
