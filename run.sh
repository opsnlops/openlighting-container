#!/usr/bin/env bash

echo "Starting OLA..."
CONTAINER_ID=$(docker run -d --rm \
    --name="ola" \
    --net host \
    -v /var/run/dbus:/var/run/dbus \
    -v /home/april/ola:/home/olad/.ola \
    --device=/dev/serial/by-id/usb-ENTTEC_DMX_USB_PRO_EN377982-if00-port0:/dev/ttyUSB0 \
    opsnlops/openlighting:latest)

sleep 2
docker logs $CONTAINER_ID

