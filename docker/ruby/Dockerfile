
# dockerファイルは基本逐一os指定をしないと動かないがここでは
# FROM ruby:3.1の中にLinux環境（具体的には、Debianベースのイメージ)が含まれているのでok
FROM ruby:3.1.4

COPY ./Gemfile ./Gemfile.lock ./

RUN apt-get update && \
    apt-get -y install \
    nodejs \
    libpq-dev \
    git \
    zip \
    unzip \
    npm \
    vim \
    fish

RUN bundle install

# Node.js and npm version check
RUN npm -v

RUN npm install --global yarn

# アプリケーションの依存関係をインストール
RUN yarn install

# webwebpackを入れないとrubyコンテナの中に入れない
#詳しくはdocker-compose logs rubyを実行
RUN yarn add webpack webpack-cli

# # install Node.js
COPY --from=node:16.16.0 /usr/local/bin /usr/local/bin
COPY --from=node:16.16.0 /usr/local/lib /usr/local/lib

WORKDIR /var/www/html

CMD [ "yarn", "start" ]
