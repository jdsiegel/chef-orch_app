Description
===========

orch\_app configures all the moving parts to get a node ready to host a
ruby app. It installs ruby and sets up runit and foreman to run any services
generated from an app's Procfile.

Ruby version management is handled by 
[chruby](https://github.com/postmodern/chruby).

The goal is to provide a simple way to set up a ruby app by just setting
a few node attributes. No custom cookbook or use of LWRPs required.

Requirements
============

Chef 10.10.0+

Assumptions
-----------

* Your app specifies all of its long-running services with a Procfile
* The user accounts already exist
* One app for one user using one version ruby

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 12.04

Cookbooks
---------

This cookbook depends on the following external cookbook:

* [ruby\_build](https://github.com/opscode-cookbooks/ruby_build)
* [runit](https://github.com/opscode-cookbooks/runit)

Attributes
==========

### chruby (optional)

A hash describing some options for installing chruby:

* version        - the version of chruby
* url            - the url of the chruby tarball
* checksum       - the sha256 hash of the chruby tarball
* force\_install - install chruby even if it's already installed

### apps

A list of hashes describing one or more ruby apps that will run on this
host. Each hash accepts the following:

* name          - the app's name
* user          - the app's user account
* ruby\_version - the app's ruby version. It is compiled by
  ruby\_build
* bundler\_version (optional) - A version of bundler specific to this
  app

### rubies\_path (optional)

The path where rubies are placed. Defaults to /opt/rubies

Usage
=====

* Add recipe[orch\_app] to the run list for your node and set the the
  apps attribute with the list of apps.

License and Author
==================

- Author:: Jeff Siegel

Copyright:: 2013 Jeff Siegel

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
