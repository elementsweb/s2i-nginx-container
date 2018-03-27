# s2i-nginx-container
An Openshift source-to-image base container for an Nginx web server.

Features extended from `centos/s2i-base-centos7`:
- Installation of Nginx 1.12.1 (stable) with nginx.conf

## Development
More information about how to develop this S2I builder image can be found in the [Creating S2I Builder Image](./docs/creating-s2i-builder-image.md) docs.

### Building the image
Run `make build` to instruct Docker to build the image.

### Testing the image
Run `make test` to instruct Docker to build a test image and run tests in test/run.

Tests will check to see if a 200 status code response is returned after running the Nginx server with a non-root user.

### Create Openshift Image Stream
See [Creating an Image Stream by Manually Pushing an Image](https://docs.openshift.com/container-platform/3.4/dev_guide/managing_images.html#creating-an-image-stream-by-manually-pushing-an-image) to see how to create a new image stream for your base container. You will reference the new image stream in templates that build source code using this base container.
