# README

These directories contain Dockerfiles that are useful for testing installation and upgrades.

All examples assume the `PUPPET_FORGE_TOKEN` environment variable is set.

## Usage

### Installation

This case uses the `install_shell.sh` task to install puppet-agent 8.x and verifies
you can run `puppet apply`

#### Usage

#### Perform default install

```
$ docker/bin/install.sh
...
  Installing       : puppet-agent-8.10.0-1.el8.x86_64
...
Notice: Scope(Class[main]): puppet apply
Notice: Compiled catalog for 201fbd3e5e0b in environment production in 0.02 seconds
Notice: Applied catalog in 0.02 seconds
```

#### Install a specific platform

```
$ docker/bin/install.sh fedora
...
  Installing       : puppet-agent-8.10.0-1.fc40.x86_64
...
Notice: Scope(Class[main]): puppet apply
Notice: Compiled catalog for 881280c14d12 in environment production in 0.02 seconds
Notice: Applied catalog in 0.02 seconds
```

### Upgrades

This case installs a "before" version of puppet-agent 7.x and verifies you can
use this module to upgrade to an "after" version of puppet-agent 8.x.

#### Usage

##### Perform default upgrade

```
$ docker/bin/upgrade.sh
...
Notice: /Stage[main]/Puppet_agent::Install/Package[puppet-agent]/ensure: ensure changed '7.34.0-1.el8' to '8.10.0'
```

##### Upgrade a specific platform

```
$ docker/bin/upgrade.sh rocky
...
Notice: /Stage[main]/Puppet_agent::Install/Package[puppet-agent]/ensure: ensure changed '7.34.0-1.el8' to '8.10.0'
```

##### Upgrade from a specific version

```
$ docker/bin/upgrade.sh rocky 7.12.0
...
Notice: /Stage[main]/Puppet_agent::Install/Package[puppet-agent]/ensure: ensure changed '7.12.0-1.el8' to '8.10.0'
```

##### Upgrade from and to specific versions

```
$ docker/bin/upgrade.sh rocky 7.34.0 8.11.0
...
Error: /Stage[main]/Puppet_agent::Install/Package[puppet-agent]/ensure: change from '7.12.0-1.el8' to '8.11.0' failed: Could not update: Execution of '/usr/bin/yum -d 0 -e 0 -y update puppet-agent-8.11.0' returned 1
```
