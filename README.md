Description
===========

orch\_web is a simple cookbook for setting up nginx as a reverse proxy for one
or more upstream rails/rack servers. It uses the 'nginx::source' recipes from the
[nginx](https://github.com/opscode-cookbooks/nginx) cookbook for
configuration.

The goal is to provide a simple way to set up a reverse proxy server by just setting
a few node attributes. No custom cookbook or use of LWRPs required.

Requirements
============

Chef 10.10.0+

Assumptions
-----------

* You are proxying rails/rack apps via unicorn, puma, or some other
  server. Passenger is not supported.
* Your deploy process will place all static assets in the app's root
  path on the node that includes the orch\_web recipe

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 12.04

Cookbooks
---------

This cookbook depends on the following external cookbook:

* [nginx](https://github.com/opscode-cookbooks/nginx)

Attributes
==========

### apps

A list of hashes describing the set of virtual hosts for each app. Each hash accepts the
following:

* name - the name of the rails/rack app (required)
* root\_path - the path of the app's public directory. It's assumed the app
  static assets are deployed here (required)
* servers - a list of upstream server addresses (IP4/6 or unix socket)
* port - the virtual host's listening port (default: 80)
* hostname - the virtual host's hostname (default: \_)

## External attribute changes

This cookpage makes opinionated changes to the nginx default attributes.
You can still change orch\_web's decisions by setting the nginx attributes at
either the node or override levels.

### default\_site\_enabled (nginx)

This is set to false

Usage
=====

* Add recipe[orch\_web] to the run list for your proxy node and set the the
  apps attribute.

License and Author
==================

- Author:: Jeff Siegel

Copyright:: 2012 Jeff Siegel

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
