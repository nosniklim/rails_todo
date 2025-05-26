FROM ruby:2.6.3

# ビルド時にNode.jsとYarnの更新に必要なcurlをインストール
RUN apt-get update -qq && apt-get install -y nodejs curl

# 最新のYarnをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# コンテナ内の作業ディレクトリを割り当て
WORKDIR /app

# ビルド時にGemをインストール
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# ホストのソースコードをDockerにコピー
COPY . /app

# コンテナ起動時にRailsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
