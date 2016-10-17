# nssm

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)

## Overview

This module is a couple of defined types to install a service, and set the parameters for that service.  This will obviously require NSSM to be installed

## Module Description

```
  # Install the service
  nssm::install { 'Jenkins_Agent':
    ensure       => present,
    program      => 'C:\Program Files\Java\jdk1.7.0_79\bin\java.exe',
    service_name => 'Jenkins_Agent',
  }
```

```
  # Service Management
  nssm::set { 'Jenkins_Agent':
    service_user        => 'LocalSystem',
    service_interactive => true,
    create_user         => false,
    app_parameters      => "-jar C:\swarm-jar-with-dependencies.jar -mode exclusive -executors 8 -username jenkins -password password -master http://localhost:8080 -labels windows -fsroot C:\opt\ci",
    require             => Nssm::Install['Jenkins_Agent'],
  }
```
