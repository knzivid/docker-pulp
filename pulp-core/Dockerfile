FROM fedora:31 as build
ENV PYTHONUNBUFFERED 1

# https://pypi.org/project/pulpcore/#history
ENV PULP_VERSION 3.12.2

# NOTE: Extension versions must support pulpcore version!
# https://pypi.org/project/pulp-file/#history
ENV PULP_FILE_VERSION 1.7.0
# https://pypi.org/project/pulp-container/#history
ENV PULP_CONTAINER_VERSION 2.5.2
# https://pypi.org/project/pulp-deb/#history
ENV PULP_DEB_VERSION 2.11.1

# Plugins requies older version than one from Git (3.1)
#ENV PULP_GIT="https://github.com/pulp/pulpcore.git"
#ENV PULP_REF="2d84e2edabeeff56e718e273128ab6a65cf93c16"

# Install build dependencies
RUN yum install -y \
      curl \
      python3 python3-virtualenv python3-devel \
      createrepo_c-devel \
      cmake \
      make \
      gcc \
      git \
      libpq-devel \
      ninja-build \
      cairo-devel \
      libpq-devel \
      rpm-devel \
      file-devel \
      sqlite-devel \
      libxml2-devel \
      zlib-devel \
      expat-devel \
      libmodulemd-devel \
      gobject-introspection-devel \
      cairo-gobject-devel \
      zchunk-devel

# Install pulp
RUN virtualenv -p python3 /opt/pulp
#RUN git clone $PULP_GIT /usr/src/pulpcore && \
#    cd /usr/src/pulpcore && git checkout $PULP_REF && \
#    /opt/pulp/bin/pip install -e .[postgres]

# Install plugins
RUN /opt/pulp/bin/pip install \
    pulpcore==$PULP_VERSION \
    pulp-file==$PULP_FILE_VERSION \
    pulp-container==$PULP_CONTAINER_VERSION \
    pulp-deb==$PULP_DEB_VERSION \
    pip \
    django-storages[boto3] \
    django-storages[azure] \
    gunicorn

## Main image
FROM fedora:31
ENV PYTHONUNBUFFERED 1
ENV PATH /opt/pulp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV DJANGO_SETTINGS_MODULE="pulpcore.app.settings"

COPY --from=build /opt/pulp /opt/pulp

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

ARG IMAGE_USER
ARG IMAGE_UID
ARG IMAGE_GID
RUN groupadd -g $IMAGE_GID $IMAGE_USER
RUN useradd --system -m -d /var/lib/pulp -s /sbin/nologin -u $IMAGE_UID -g $IMAGE_GID $IMAGE_USER

RUN yum install -y curl \
      python3 \
      createrepo_c-libs \
      postgresql \
      libpq \
      sqlite \
      libxml2 \
      zlib \
      file-libs \
      libmodulemd \
      gobject-introspection \
      expat \
      zchunk-libs \
    && yum clean all

WORKDIR /var/lib/pulp
USER $IMAGE_USER
