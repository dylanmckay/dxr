# A docker setup for DXR development
#
# This image has DXR and various compilers installed, so it can be used for
# indexing, serving web, and interactive debugging.
#
# This image should not be used as a base for production setups. Those would
# want separate images (and separate machines) for indexing. Also, we leave out
# some image size optimizations and introduce would-be security holes for the
# sake of a good dev experience.

FROM ubuntu:16.04

MAINTAINER Erik Rose <erik@mozilla.com>

COPY tooling/docker/scripts/set_up_ubuntu.sh /tmp/
RUN DEBIAN_FRONTEND=noninteractive /tmp/set_up_ubuntu.sh

COPY tooling/docker/scripts/set_up_common.sh /tmp/
RUN DEBIAN_FRONTEND=noninteractive /tmp/set_up_common.sh

# Give root a known password so devs can become root:
RUN echo "root:docker" | chpasswd

# Install Graphviz, needed only for building docs.
# Not running apt-get clean, to keep dev experience snappy.
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install graphviz cmake git-svn # FIXME: remove cmake and git-svn

RUN useradd --create-home --home-dir /home/dxr --shell /bin/bash --groups sudo --uid 1000 dxr
RUN echo "dxr:docker" | chpasswd

# Change ownership of volume mount points so they're accessible
# to the dxr user. This is not possible via docker-compose.yml.
RUN mkdir -p /venv && chown dxr:dxr /venv
RUN mkdir -p /code && chown dxr:dxr /code
RUN mkdir -p /builds && chown dxr:dxr /builds

USER dxr

# Use clang for building everything.
ENV CC  clang
ENV CXX clang++

# Activate a virtualenv. make will make it later. Also, set SHELL so mach
# doesn't complain while building Firefox. Other things probably expect it as
# well.
ENV VIRTUAL_ENV=/venv PATH=/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin SHELL=/bin/bash

# Copy the DXR repository into the dxr user's home.
COPY --chown=dxr ./ /home/dxr/dxr

WORKDIR /home/dxr/dxr

RUN make all

EXPOSE 8000

CMD ["/home/dxr/dxr/tooling/docker/scripts/start.sh"]
