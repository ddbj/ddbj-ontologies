FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/taxdump

WORKDIR /usr/src/app

COPY . .

# COPY Gemfile Gemfile.lock ./
RUN bundle install

CMD ["ruby, "-v"]
