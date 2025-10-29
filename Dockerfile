FROM ruby:2.6-bullseye

# Debian Bullseyeの署名鍵問題の対応: apt-get updateでパッケージリストを更新するためのkeyringとhttpsを有効化
RUN set -eux; \
  sed -i 's|http://deb.debian.org|https://deb.debian.org|g' /etc/apt/sources.list; \
  sed -i 's|http://security.debian.org|https://security.debian.org|g' /etc/apt/sources.list; \
  apt-get -o Acquire::AllowInsecureRepositories=true update; \
  apt-get install -y --no-install-recommends ca-certificates debian-archive-keyring gnupg; \
  apt-get update; \
  # NOTE: Dockerイメージ内の不要なパッケージリストはクリーンアップしておく（キャッシュ削除）
  rm -rf /var/lib/apt/lists/*

# NOTE: RUNコマンドオプション
#  -e: 即停止
#  -u: 変数が未定義なら停止
#  -x: 実行中のコマンドを全て表示

# ビルド時に必要なツールをインストール
RUN set -eux; \
  apt-get update -qq && apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    fonts-liberation \
    libappindicator3-1 \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk1.0-0 \
    libpangocairo-1.0-0 \
    libxcomposite1 \
    libxrandr2 \
    libxi6 \
    libgconf-2-4 \
    xdg-utils; \
  rm -rf /var/lib/apt/lists/*

# Node 20 を NodeSource からインストール
RUN set -eux; \
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -; \
  apt-get update -qq && apt-get install -y --no-install-recommends nodejs; \
  rm -rf /var/lib/apt/lists/*

 # Yarnをインストール
 # FIXME: 依存関係を解決するためruby2.6.3で使用していた1.22.22を指定（Rubyバージョンアップ時に見直し）
 RUN npm i -g yarn@1.22.22

# Google Chromeをインストール
RUN set -eux; \
  install -m 0755 -d /etc/apt/keyrings; \
  curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/google.gpg; \
  chmod a+r /etc/apt/keyrings/google.gpg; \
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list; \
  apt-get update -qq && apt-get install -y --no-install-recommends google-chrome-stable; \
  rm -rf /var/lib/apt/lists/*

# hotfix: Bundlerのバージョンを固定してインストール
RUN gem install bundler -v 2.4.22

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
