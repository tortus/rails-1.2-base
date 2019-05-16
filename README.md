# Rails 1.2 base

Final full base image for legacy Rails 1.2 apps in their full original environment.

Adds the following to the Passenger 3 image:

* Imagemagick
* PHP 5
* Mod PHP 5
* PostgreSQL headers and client
* host.docker.internal workaround for linux
* 'setuser' script borrowed from phusion/baseimage-docker
* migrates DB on startup
* dnsutils (for nslookup, etc)

Ruby Gems:

* postgres 0.7.9.2008.01.28
* rmagick 2.15.4

## Database migration

Database will be automatically migrated on application start. Set MIGRATE=false to prevent this. (Useful in development, since it certainly slows down booting.)
