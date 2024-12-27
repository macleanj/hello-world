# Overview

Simple Hello World website for platform testing.

## Build

```bash
# Locally build and pushed image (example for version 5.3)
# docker login
# docker buildx create --name multiarch --driver docker-container --use # First time docker setup
docker buildx build --push --platform linux/arm/v7,linux/arm64,linux/amd64 --tag jmaclean/hello-world:6.1 .

# Copy specific architecture
crane copy <SOURCE> <DESTINATION>
```
