FROM ruby:3.1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle lock --update && \
    bundle install --jobs=4

COPY config.ru app.rb ./

STOPSIGNAL SIGINT

EXPOSE 2410

CMD ["rackup", "-p2410", "--host", "0.0.0.0", "-s", "puma"]
