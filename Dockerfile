#
# Dockerfile
#

FROM debian:jessie
MAINTAINER Yann Verry <docker@verry.org>

# install build env
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get -y install wget git build-essential zlib1g-dev zlib1g zlibc locales ca-certificates libssl-dev libsqlite3-dev
   
# clone cryptcheck, cryptcheck-rails
RUN cd /opt && \
    git clone https://github.com/yanntech/cryptcheck-rails && \
    git clone https://github.com/yanntech/cryptcheck

WORKDIR /usr/src

# OpenSSL
ENV OPENSSL_VERSION 1.0.2d
RUN wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz && \
    tar xf openssl-$OPENSSL_VERSION.tar.gz && \
    cd openssl-$OPENSSL_VERSION && \
    ./config shared && \
    make && \
    make install

# add CA and cacert
RUN mkdir /usr/local/share/ca-certificates/cacert.org && \
    wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt && \
    /usr/sbin/update-ca-certificates && \
    rmdir /usr/local/ssl/certs && \
    ln -s /etc/ssl/certs /usr/local/ssl/certs

# Ruby
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.3
RUN wget http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz && \
    tar xf ruby-$RUBY_VERSION.tar.gz && \
    cd ruby-$RUBY_VERSION && \
    patch -p0 < /opt/cryptcheck/ruby-openssl-dh.patch && \
    ./configure --prefix=/usr --with-openssl=yes --with-openssl-dir=/usr/local/ssl && \
    make && \
    make install

WORKDIR /opt/cryptcheck

# bundle
RUN gem install bundler && \
	bundle install


WORKDIR /opt/cryptcheck-rails

# gem
RUN	bundle install --without development && \
	RAILS_ENV=staging bundle exec rake assets:precompile && \
	bundle install --without development test assets && \
	bundle clean --force && \
	bundle install --deployment --without development test assets && \
	gem install puma && \
	echo "production:\n  secret_key_base: $(rake secret)" > config/secrets.yml 

# Cleanup
RUN apt-get -y purge build-essential zlib1g-dev krb5-locales && \
    apt-get -y autoremove

# Set the locale
ENV LC_ALL C.UTF-8

# RUBY ENV
ENV REDIS_URL=redis://redis:6379/
ENV ES_URL=http://elasticsearch:9200/
ENV RAILS_SERVE_STATIC_FILES=true

# EXPOSE
EXPOSE 9292:9292

# copy entrypoint
ADD docker/entrypoint.sh /entrypoint.sh

# entrypoint
ENTRYPOINT['./entrypoint.sh']
