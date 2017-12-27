FROM aeris/cryptcheck AS builder
MAINTAINER aeris <aeris@imirhil.fr>

RUN apk add --update make gcc g++ libxml2-dev yaml-dev zlib-dev nodejs

WORKDIR /cryptcheck-rails/
COPY . /cryptcheck-rails/

RUN sed -i "/'therubyracer'/d" Gemfile && \
	sed -i "/^  therubyracer$/d" Gemfile.lock && \
	bundle config --local local.cryptcheck ../cryptcheck && \
	bundle install --deployment --without test development && \
	RAILS_ENV=assets bundle exec rails assets:precompile && \
	rm -rf vendor/bundle && \
	RAILS_ENV=production bundle install --deployment --without test development

FROM aeris/cryptcheck AS frontend
MAINTAINER aeris <aeris@imirhil.fr>

ENV RAILS_ENV=production
WORKDIR /cryptcheck-rails/
COPY --from=builder /cryptcheck-rails/ /cryptcheck-rails/
