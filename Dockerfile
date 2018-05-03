#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

MAINTAINER Stano Samek <stanislav.samek@gmail.com>

# Pull base image.
FROM centos:7

# Install Nginx.
RUN \
  yum -y install --setopt=tsflags=nodocs centos-release-scl-rh && \
  yum -y update --setopt=tsflags=nodocs && \
  yum -y install --setopt=tsflags=nodocs scl-utils rh-nginx18 && \
  yum clean all && \
  mkdir -p /usr/share/nginx/html \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443

# Install Openssl
RUN \
    yum install -y openssl && \
    openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 && \
    openssl rsa -passin pass:x -in server.pass.key -out server.key && \
    rm server.pass.key && \

# Create self signed certificate
RUN \
    openssl req -new -key server.key -out server.csr \
    -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com" && \
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
