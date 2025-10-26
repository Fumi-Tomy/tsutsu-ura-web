# Ruby のバージョンを指定 
FROM ruby:3.4.6-alpine3.22

# タイムゾーンの設定
ENV TZ=Asia/Tokyo

# 環境変数の設定
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development"
ARG BUNDLER_VERSION=2.5.8

# apk の更新と必要なパッケージのインストール
RUN apk update --no-cache && \
    apk add --no-cache \
        bash \
        vim \
        git \
        build-base \
        postgresql-dev \
        nodejs \
        npm \
        yarn \
        imagemagick \
        libjpeg-turbo-dev \
        libpng-dev \
        libpq \
        libffi-dev \
        tzdata \
        yaml-dev && \
    rm -rf /var/cache/apk/*

# 作業ディレクトリの設定
WORKDIR /usr/src/blog

# ホストのアプリケーションコードをコンテナにコピー
COPY Gemfile Gemfile.lock ./

# bundler のバージョンを指定してインストール
RUN gem install bundler --version $BUNDLER_VERSION

# Gem のインストール
# --jobs $(nproc): 並列でインストール
# --retry 3: 失敗時に3回リトライ
RUN bundle install --jobs $(nproc) --retry 3

#アプリケーションのソースコードをコピー
COPY . .

ENV SECRET_KEY_BASE=dummy
RUN bundle exec rails assets:precompile

# 起動スクリプトをコンテナにコピーして実行権限を付与
RUN chmod +x /usr/src/blog/entrypoint.sh

# このスクリプトをエントリーポイントとして設定
ENTRYPOINT ["entrypoint.sh"]

# デフォルトの起動コマンドとしてPumaサーバーを指定
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
