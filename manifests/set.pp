# == Define: nssm:set
#
# Define to configure Windows Service using 'nssm set'
#
# === Parameters
# [*create_user*]
#   Boolean to control whether the user should be created
#    If true, dicates $command format due to:
#      - service accounts need to be prefixed with a .\
#    If default of false:
#      - Do not prefix with .\ otherwise command wil fail
#
# [*service_interactive*]
#   Allow service to interact with desktop
#   Defaults to false
#
define nssm::set (
  $create_user         = false,
  $service_name        = $title,
  $service_user        = 'LocalSystem',
  $service_pass        = undef,
  $service_interactive = false,
  $app_parameters      = undef,
) {

  if $create_user {
    $command = "nssm set '${service_name}' ObjectName '.\\${service_user}' '${service_pass}'"

    user { $service_user:
      ensure   => present,
      comment  => "CI User to run $service_name",
      groups   => ['BUILTIN\Administrators', 'BUILTIN\Users'],
      password => $service_pass,
    }
  }
  else {
    $command = "nssm set '${service_name}' ObjectName '${service_user}' '${service_pass}'"
  }

  # Set Encoding to Unicode due to ascii null character
  # http://grokbase.com/t/gg/salt-users/152vyb5vx1/weird-whitespace-problem-getting-data-out-of-cmd-run-nssm-on-windows
  exec { 'set_service_name':
    command  => $command,
    path     => 'C:\Program Files\nssm-2.24\win64',
    unless   => "[Console]::OutputEncoding = [System.Text.Encoding]::Unicode; \$args = nssm get '${service_name}' ObjectName; \$cmp = \$args.Contains(\"${service_user}\"); if (\$cmp -eq \"True\") {exit 0} else {exit 1}",
    provider => powershell,
  }

  exec { 'set_app_parameters':
    command  => "nssm set '${service_name}' AppParameters '${app_parameters}'",
    path     => 'C:\Program Files\nssm-2.24\win64',
    unless   => "[Console]::OutputEncoding = [System.Text.Encoding]::Unicode; \$args = nssm get '${service_name}' AppParameters; \$cmp = \$args.Contains(\"${app_parameters}\"); if (\$cmp -eq \"True\") {exit 0} else {exit 1}",
    provider => powershell,
  }

  if $service_interactive {
    exec { 'set_service_interactive_process':
      command => "nssm reset '${service_name}' ObjectName; nssm set '${service_name}' Type SERVICE_INTERACTIVE_PROCESS",
      path    => 'C:\Program Files\nssm-2.24\win64',
      unless  => "[Console]::OutputEncoding = [System.Text.Encoding]::Unicode; \$args = nssm get '${service_name}' Type; \$cmp = \$args.Contains(\"INTERACTIVE\"); if (\$cmp -eq \"True\") {exit 0} else {exit 1}",
      provider => powershell,
    }
  }

}
