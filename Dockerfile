FROM ruby:2.6.3-alpine

ENV DEV_PACKAGES="build-base sqlite-dev yarn"
ENV RAILS_PACKAGES="nodejs tzdata"

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $DEV_PACKAGES $RAILS_PACKAGES

ENV APP_PATH /rails-docker

WORKDIR $APP_PATH

ENV RAILS_ENV production
ENV NODE_ENV production

COPY Gemfile Gemfile.lock yarn.lock ./

RUN bundle install --jobs 10 --quiet

COPY . .

RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
