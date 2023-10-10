# Our TRE development container

## Overview

[![Docker Build & Push](https://github.com/rmgpanw/rwd/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/rmgpanw/rwd/actions/workflows/docker-build-push.yml)

Creates a docker image using GitHub Actions, based on [rocker/geospatial](https://hub.docker.com/r/rocker/geospatial/tags) with additional R packages and their system dependencies installed.

Github actions is used to build the docker image and push this to [Docker Hub](https://hub.docker.com/repository/docker/rmgpanw/geospatial/general). The image tag is a concatenation of the original [rocker/geospatial](https://hub.docker.com/r/rocker/geospatial/tags) image tag with the first 7 characters for the commit in this GitHub repository, from which the image was built. For example, the tag name `4.3-be9be18` would indicate that image [rocker/geospatial:4.3](https://hub.docker.com/layers/rocker/geospatial/4.3/images/sha256-2bf6a399daf43456975471c2a9b337dc8c5043460c3499c0e579dd2699898477?context=explore) was used in commit `be9be18`

See also: 

- [rocker-versioned2 GitHub README](https://github.com/rocker-org/rocker-versioned2) for comparison of `r-ver` with `r-base` rocker images. 
- [Rocker Project website](https://rocker-project.org/images/#the-versioned-stack) for details on various image options.

## Usage instructions

- Pull image with `docker pull rmgpanw/geospatial:<TAG>`
- Open a terminal in the directory to be bind mounted and launch container with (changing 'password' to something more secure):

```
project_dir=$(pwd)

docker run -e PASSWORD=password \
--rm -p 8787:8787 \
-v ${project_dir}:/home/rstudio/my-project \
rmgpanw/geospatial:<TAG>
```

- Open a browser window with `localhost:8787` and login to RStudio with username 'rstudio' and the password set in the previous step

