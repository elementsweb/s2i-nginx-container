# s2i-nginx-container
FROM centos/s2i-base-centos7

EXPOSE 8080

LABEL maintainer="elementsweb"

ENV NGINX_VERSION=1.12.1 \
    NAME=nginx

ENV CONFIG="\
    --conf-path=/etc/nginx/nginx.conf"

ENV SUMMARY="Platform for running Nginx web server to host assets" \
    DESCRIPTION="Nginx $NODEJS_VERSION docker container for hosting assets."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Nginx $NGINX_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,$NAME,$NAME$NGINX_VERSION" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i"

RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && tar -xvf nginx-$NGINX_VERSION.tar.gz \
    && cd nginx-$NGINX_VERSION \
    && ./configure $CONFIG \
    && make \
    && make install

ENV PATH=/usr/local/nginx/sbin/:$PATH

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /usr/local/nginx

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

COPY nginx.conf /etc/nginx/nginx.conf

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
