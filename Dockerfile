FROM ruby:2.6-bullseye

# ビルド時に必要なツールをインストール
RUN apt-get update -qq && apt-get install -y \
  curl \
  ca-certificates \
  gnupg \
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
  xdg-utils

# Node 20 を NodeSource からインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs

 # Yarnをインストール
 # FIXME: 依存関係を解決するためruby2.6.3で使用していた1.22.22を指定（Rubyバージョンアップ時に見直し）
 RUN npm i -g yarn@1.22.22

# Google Chromeをインストール
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
  apt-get update && apt-get install -y google-chrome-stable

# ChromeDriverをインストール
RUN CHROMEDRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
  wget -N https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  mv chromedriver /usr/local/bin/chromedriver && \
  chmod +x /usr/local/bin/chromedriver && \
  rm chromedriver_linux64.zip

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
