# Better LAMP stack

GitHub: [https://github.com/GSCloud/better_lamp_stack]  

Run modern LAMP stack applications.

## Usage

* **make** -> CLI help

## Install

* run "**make install**" to install minimal set
* run "**make everything**" to install simply everything - for a clean new install incl. extensions
* run "**make extensions**" to add PHP extensions
* included Apache 2 configuration to run this on as a real public site through proxying (TLS certificates needed)
* uncomment TLS verification commands if using Authenticated origin pull [https://developers.cloudflare.com/ssl/origin-configuration/authenticated-origin-pull]
* don't forget to run "**a2enmod proxy**" command on the host
* use **PMA** or **Adminer** to import MySQL data

## Remove

* run "**make remove**"
* persistent data will remain

## Purge

* run "**make purge**"
* removes everything permanently

## Configuration

* configuration -> **.env**
* extra configuration directives for PHP -> INI/ subfolder

## Default Storage

* **Application** -> **www/**
* **MySQL** database -> **db/**

Author: Fred Brooker 💌 <git@gscloud.cz>
