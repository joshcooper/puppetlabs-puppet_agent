# README

These directories contain Dockerfiles that are useful for testing installation and upgrades.

## Usage

### Installation

TBD

### Upgrades

This case installs a "before" version of puppet-agent 7.x and verifies you can
use this module to upgrade to an "after" version of puppet-agent 8.x.

#### Usage

All examples assume the `PUPPET_FORGE_TOKEN` environment variable is set.

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
