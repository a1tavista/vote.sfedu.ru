FROM ruby:2.7.7-alpine3.16

ENV PATH /root/.yarn/bin:$PATH

RUN apk update && apk upgrade && \
    apk add --no-cache binutils tar gnupg \
                       curl jq python3 py3-pip bash git openssh \
                       build-base nodejs tzdata postgresql-dev

RUN /bin/bash \
  && touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /app
COPY Gemfile Gemfile.lock ./

RUN bundle config set without 'development test' && \
    bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5

ENV NODE_ENV production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_ROOT /app

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

ARG APPLICATION_HOST
ENV APPLICATION_HOST $APPLICATION_HOST

COPY . ./
RUN SECRET_KEY_BASE=testtest RAILS_ENV=production DATABASE_URL=postgresql:does_not_exist ./bin/rails assets:precompile

EXPOSE 3000
