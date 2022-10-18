FROM ruby:3.0.1-alpine

RUN apk add --update --virtual \
  runtime-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  yarn \
  libffi-dev \
  readline \
  build-base \
  libc-dev \
  linux-headers \
  readline-dev \
  file \
  git \
  tzdata \
  gcompat \
  && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/

ENV BUNDLE_PATH /gems
RUN yarn install
RUN bundle install --without development test

ENTRYPOINT ["bin/rails"]
CMD ["server", "-p", "3777", "-b", "0.0.0.0"]

EXPOSE 3777