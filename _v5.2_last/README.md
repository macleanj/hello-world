<!-- Images are build by Docker HUB Build directly connected to the GIT Hub git hook -->
# Hello World
This GIT repo and image is used for versioning and deployment testing in extremely simple CICD pipelines.

# How it works
The docker image created includes the html page displaying a version number. This version number is controlled by the VERSION environment variable (which in itself can be controlled by any other external effects like Jenkins). </br>
The page can be views on port 80 and 443 (self signed certificate).

# Persistence
In some cases persistenceStorage needs to be tested in the cloud environment. The persistenceStorage section offers the capabilities to simply upload files to the server. The files will uploaded to the directory ```/data```. In turn, this directory can than be used to test persistenceStorage.

# Loading config files
The main page will load all configuration files at startup and display the configured variable. Mind to restart the containers when changing the configuration as PHP caches the configuration.

# References
- [DinD vd DooD](https://medium.com/hootsuite-engineering/building-docker-images-inside-kubernetes-42c6af855f25)