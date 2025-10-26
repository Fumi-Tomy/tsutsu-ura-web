#!/bin/sh

set -e # スクリプトのいずれかのコマンドが失敗したら、スクリプトを終了する

# データベースのマイグレーションを実行する
echo "Running database migrations..."
bundle exec rails db:migrate
bundle exec rails db:seed

# DockerfileのCMDで渡されたコマンド（Pumaの起動など）を実行する
exec "$@"