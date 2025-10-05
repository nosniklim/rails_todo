FROM ruby:2.6-bullseye

# ビルド時に必要なツールをインストール（curl, gnupg, ca-certificates）
RUN apt-get update -qq && apt-get install -y curl ca-certificates gnupg

# Node 18 を NodeSource からインストール
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs

 # Yarnをインストール
 # FIXME: 依存関係を解決するためruby2.6.3で使用していた1.22.22を指定（Rubyバージョンアップ時に見直し）
 RUN npm i -g yarn@1.22.22

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
