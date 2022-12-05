#!/bin/bash

docker run -it \
    --name="openlighting" \
    --net host \
    -v /var/run/dbus:/var/run/dbus \
    opsnlops/openlighting:latest

