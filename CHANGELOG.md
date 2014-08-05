[TOC]

# Change Log

This file lists the current and development versions along with the associated changes made to this project.

## v1.1.0 [TBC]
* [NEW] Use [New Relic](https://addons.heroku.com/newrelic) for real-time production monitoring.

## v1.0.0 [04-AUG-2014]
* [NEW] Use [logentries](https://addons.heroku.com/logentries) for log management.
* [NEW] Added a Vagrantfile for creating [Vagrant](http://www.vagrantup.com/) virtual machines.
* [NEW] Integrated [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader) to allow compiled binaries to be uploaded to Dropbox.
* [CHANGE] Vendor packages can be downloaded from S3 or Dropbox. This is controlled by the `USE_DROPBOX` environment variable.