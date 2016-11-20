require 'puppet/parameter/boolean'

Puppet::Type.newtype(:nssm_set) do
  desc "Puppet type to set service parameters"

  newparam(:service_name, :namevar => true) do
    desc "The name of the service NSSM is to manage"
  end

  newproperty(:create_user) do
    desc "Whether or not to create local user account"
    newvalues(:true, :false)
    defaultto :false
  end

  newproperty(:service_user) do
    desc "Username underwhich to run the service"
    defaultto "LocalSystem"
  end

  newproperty(:service_pass) do
    desc "Password for the :service_user"
  end

  newproperty(:service_interactive) do
    desc "Whether or not to run service interactively"
    newvalues(:true, :false)
    defaultto :false
  end

  newproperty(:app_parameters) do
    desc "Set additional app parameters"
  end

  newproperty(:nssm_path) do
    desc "Option to specify path to nssm command"
    defaultto "C:\Program Files\nssm-2.24\win64"
  end
end
