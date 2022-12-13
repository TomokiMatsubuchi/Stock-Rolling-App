FROM ruby:3.0.1


RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
  && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qq \
  && apt-get install -y google-chrome-stable libnss3 libgconf-2-4

# ChromeDriver のインストール
# 現在の最新のバージョンを取得し、それをインストールする。
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
  && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
  && unzip /tmp/chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin/

RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /StockRollingApp

# install nodejs(16.x)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# install yarn
RUN npm install --global yarn


COPY . /StockRollingApp
#RUN yarn add tailwindcss@2 postcss@8 @fullhuman/postcss-purgecss@4 postcss-loader@4 autoprefixer@10
RUN yarn add jquery
# gem
COPY ./Gemfile /StockRollingApp
COPY ./Gemfile.lock /StockRollingApp
#COPY Gemfile* /StockRollingApp/
RUN gem install bundler
RUN bundle config set --local disable_checksum_validation true
RUN bundle config set force_ruby_platform true
RUN bundle install

#GithubActionではsecret.ymlがないため以下のコマンドは通らないのでAWS上で実行
#RUN bundle exec rails assets:precompile RAILS_ENV=production

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]