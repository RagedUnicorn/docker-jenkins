# docker-jenkins

> A docker base to build a container for Jenkins based on Alpine Linux

### Using the image

#### Start container

The container can be easily started with `docker-compose` command.

```
docker-compose up -d
```

Once the container is running navigate to http://[dockerhost]:8080 and finish the configuration. The secret password that jenkins automatically sets can be found by looking into the container with `docker exec -it [container_id] /bin/sh`. Jenkins puts the initial password to the following location: `/var/lib/jenkins/secrets/initialAdminPassword`.

#### Stop container

To stop all services from the docker-compose file

```
docker-compose down
```

## Dockery

In the dockery folder are some scripts that help out avoiding retyping long docker commands but are mostly intended for playing around with the container. For production use docker-compose should be used.

#### Build image

The build script builds an image with a defined name

```
sh dockery/dbuild.sh
```

#### Run container

Runs the built container. If the container was already run once it will `docker start` the already present container instead of using `docker run`

```
sh dockery/drun.sh
```

#### Attach container

Attaching to the container after it is running

```
sh dockery/dattach.sh
```

#### Stop container

Stopping the running container

```
sh dockery/dstop.sh
```

## Persistence

The container is storing data in a docker volume `/var/jenkins_home`. Jobs and configuration are persisted within this volume.

## Healthcheck

The production and the stack image supports a simple healthcheck whether the container is healthy or not. This can be configured inside `docker-compose.yml` or `docker-compose.stack.yml`

Containers that depend on this container can make sure that it is up and running before starting up themselves.

```
depends_on:
  jenkins:
    condition: service_healthy
```

This will prevent the depending container from starting up until this service is in a healthy state.

## Development

To debug the container and get more insight into the container use the `docker-compose.dev.yml` configuration.

```
docker-compose -f docker-compose.dev.yml up -d
```

By default the launchscript `/docker-entrypoint.sh` will not be used to start the Jenkins process. Instead the container will be setup to keep `stdin_open` open and allocating a pseudo `tty`. This allows for connecting to a shell and work on the container. A shell can be opened inside the container with `docker attach [container-id]`. Redis itself can be started with `./docker-entrypoint.sh`.

## Links

Alpine packages database
- https://pkgs.alpinelinux.org/packages

## License

Copyright (c) 2017 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
