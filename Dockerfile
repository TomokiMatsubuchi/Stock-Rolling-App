FROM ruby:3.0.1


RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /myapp


# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# install yarn
RUN npm install --global yarn


COPY . /myapp

# gem
COPY ./Gemfile /myapp
COPY ./Gemfile.lock /myapp
#COPY Gemfile* /myapp/
RUN gem install bundler
RUN bundle config set --local disable_checksum_validation true
RUN bundle config set force_ruby_platform true
RUN bundle install

#webpacker
RUN bundle exec rails webpacker:install
RUN bundle exec rails webpacker:compile


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]