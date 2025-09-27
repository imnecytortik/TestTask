FROM ruby:3.2


RUN apt-get update -qq && apt-get install -y curl gnupg build-essential libpq-dev \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" \
       | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /usr/src/app


COPY Gemfile* ./
RUN gem install bundler
RUN bundle install


COPY . .


RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]