FROM ruby:latest

# 環境変数
ENV APP_HOME /app
ENV TZ Asia/Tokyo
ENV PORT 3001
ENV HOST 0.0.0.0

# WORKDIR：作業ディレクトリ
WORKDIR ${APP_HOME}

# ローカルのGemfileをコンテナ内の/app/Gemfileに
COPY Gemfile ${APP_HOME}/Gemfile
COPY Gemfile.lock ${APP_HOME}/Gemfile.lock

RUN apt-get update
RUN apt-get install -y \
        git

# Gemをアップデート
RUN bundle install

COPY . ${APP_HOME}

# entrypoint.shをコンテナ内の作業ディレクトリにコピー
COPY entrypoint.sh /usr/bin/

# entrypoint.shの実行権限を付与
RUN chmod +x /usr/bin/entrypoint.sh

# コンテナ起動時にentrypoint.shを実行するように設定
ENTRYPOINT ["entrypoint.sh"]

EXPOSE ${PORT}

# コンテナ起動時に実行するコマンドを指定
CMD ["rails", "server", "-b", "0.0.0.0"]