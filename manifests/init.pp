class nssm {
  ensure_resource('package', 'nssm', { ensure => 'latest' })
}
