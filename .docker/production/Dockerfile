########################
###    app config    ###
########################

FROM ruby:2.6.6 AS app

LABEL author="IdeaCrew"

ENV HOME /medicaid_gateway

RUN mkdir -p $HOME

WORKDIR $HOME

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
    GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin

RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -y imagemagick tzdata build-essential nodejs vim && \
    apt-get autoremove -y && \
    gem install bundler && \
    npm install --global yarn

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

# Setting env up
ENV RAILS_ENV='production'
ENV NODE_ENV='production'

COPY . .

RUN bundle config set without 'development test'
RUN bundle install --jobs 20 --retry 5

ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_HOST
ARG ACTION_MAILER_HOST
ARG SMTP_PORT
ARG SMTP_HOST
ARG SMTP_DOMAIN
ARG SMTP_USERNAME
ARG SMTP_PASSWORD
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION
ARG AWS_BUCKET_ROOT_NAMESPACE
ARG AWS_CONNECT_INSTANCE_ID
ARG AWS_CONNECT_INSTANCE_URL

RUN export DB_DATABASE=$DB_DATABASE && \
    export DB_USERNAME=$DB_USERNAME && \
    export DB_PASSWORD=$DB_PASSWORD && \
    export DB_HOST=$DB_HOST && \
    export ACTION_MAILER_HOST=$ACTION_MAILER_HOST && \
    export SMTP_PORT=$SMTP_PORT && \
    export SMTP_HOST=$SMTP_HOST && \
    export SMTP_DOMAIN=$SMTP_DOMAIN && \
    export SMTP_USERNAME=$SMTP_USERNAME && \
    export SMTP_PASSWORD=$SMTP_PASSWORD && \
    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID && \
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY && \
    export AWS_REGION=$AWS_REGION && \
    export AWS_BUCKET_ROOT_NAMESPACE=$AWS_BUCKET_ROOT_NAMESPACE && \
    export AWS_CONNECT_INSTANCE_ID=$AWS_CONNECT_INSTANCE_ID && \
    export AWS_CONNECT_INSTANCE_URL=$AWS_CONNECT_INSTANCE_URL && \
    bundle exec rake assets:precompile && \
    unset DB_DATABASE && \
    unset DB_USERNAME && \
    unset DB_PASSWORD && \
    unset DB_HOST && \
    unset ACTION_MAILER_HOST && \
    unset SMTP_PORT && \
    unset SMTP_HOST && \
    unset SMTP_DOMAIN && \
    unset SMTP_USERNAME && \
    unset SMTP_PASSWORD && \
    unset AWS_ACCESS_KEY_ID && \
    unset AWS_SECRET_ACCESS_KEY && \
    unset AWS_REGION && \
    unset AWS_BUCKET_ROOT_NAMESPACE && \
    unset AWS_CONNECT_INSTANCE_ID && \
    unset AWS_CONNECT_INSTANCE_URL

RUN rm -f /medicaid_gateway/config/master.key && rm -f /medicaid_gateway/config/credentials.yml.enc


########################
### web/nginx config ###
########################

FROM nginx:1.17.6-alpine as web

RUN mkdir /medicaid_gateway

# copy assets from the app build and nginx config
COPY --from=app /medicaid_gateway/public /medicaid_gateway/
COPY .docker/production/nginx.conf /etc/nginx/conf.d/medicaid_gateway.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf-bkp
