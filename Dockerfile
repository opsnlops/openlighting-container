
FROM debian:bullseye AS build

# Get fully up to date
RUN apt update && apt upgrade -y

# Install the libs from the docs
RUN apt install -y \
    libcppunit-dev libcppunit-dev uuid-dev pkg-config  \
    libncurses5-dev libtool autoconf automake g++ libmicrohttpd-dev \
    libmicrohttpd-dev protobuf-compiler libprotobuf-dev python3-protobuf \
    libprotobuf-dev libprotoc-dev zlib1g-dev bison flex make libftdi1-dev libftdi1 \
    libusb-1.0-0-dev liblo-dev libavahi-client-dev python3-numpy

# Add the source
ADD https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz /ola.tar.gz
RUN mkdir -p /build
RUN cd /build && tar -xvzf /ola.tar.gz

# Build!
RUN cd /build/ola-0.10.8/ && \
    ./configure --prefix=/opt/ola --disable-doxygen-version \
                --disable-examples --disable-unittests --disable-python-libs && \
    make -j 4 && \
    make install


FROM debian:bullseye-slim AS runner
EXPOSE 9090
EXPOSE 9010

# Get this image up to date
RUN apt update && apt upgrade -y && apt install -y \
    libmicrohttpd12 libusb-1.0-0 libprotobuf23 libftdi1-2 libavahi-client3 liblo7 \
    && rm -rf /var/lib/apt/lists/*

ENV OLA_OPTS=""
COPY --from=build /opt/ola /opt/ola
RUN useradd -g tty olad
USER olad
ENTRYPOINT /opt/ola/bin/olad $OLA_OPTS
