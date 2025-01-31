#!/usr/bin/env bash

# Install several repos: puppet 7 and 8
wget -O puppet7.rpm http://yum.puppet.com/puppet7-release-el-8.noarch.rpm
rpm -i puppet7.rpm --force --replacefiles --nodeps
wget -O puppet8.rpm https://yum-puppetcore.puppet.com/public/puppet8-release-el-8.noarch.rpm
rpm -i puppet8.rpm --force --replacefiles --nodeps

sed -i 's/^#\?username=.*/username=forge-key/' /etc/yum.repos.d/puppet8-dev-release.repo
sed -i "s/^#\\?password=.*/password=${PUPPET_FORGE_TOKEN}/" /etc/yum.repos.d/puppet8-dev-release.repo

dnf list puppet-agent --showduplicates
