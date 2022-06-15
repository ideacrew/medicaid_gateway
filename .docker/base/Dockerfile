########################
### app/rails config ###
########################

FROM ruby:2.7.6 AS app

LABEL author="IdeaCrew"

ARG NODE_MAJOR

# NodeJS download/config
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Yarn download/config
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

ARG YARN_VERSION
# Install required packages/libraries
RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -y default-jre git gcc openssl libyaml-dev libyaml-cpp-dev libyaml-cpp0.6 libffi-dev libffi6 libreadline-dev libsodium-dev \
    zlibc libgdbm-dev libncurses-dev autoconf fontconfig unzip zip sshpass bzip2 libxrender1 libxext6 ruby-dalli \
    build-essential nodejs yarn=$YARN_VERSION-1 && \
    apt-get autoremove -y

# Configure bundler and PATH, install bundler version
ENV LANG=C.UTF-8 \
    GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH $BUNDLE_BIN:$GEM_HOME/gems/bin:$PATH

ARG BUNDLER_VERSION_OVERRIDE
ENV BUNDLER_VERSION=$BUNDLER_VERSION_OVERRIDE
RUN gem update --system && gem install bundler:$BUNDLER_VERSION

# Configure app home directory
ENV HOME /medicaid_gateway
RUN mkdir -p $HOME
WORKDIR $HOME
COPY . $HOME

RUN yarn install

# Setting env up
#ARG MEDICAID_GATEWAY_DB_HOST
#ARG MEDICAID_GATEWAY_DB_PORT
#ARG MEDICAID_GATEWAY_DB_NAME
#ARG RABBITMQ_URL
ENV RAILS_ENV='production'
ENV NODE_ENV='production'
#ENV MEDICAID_GATEWAY_DB_HOST=$MEDICAID_GATEWAY_DB_HOST
#ENV MEDICAID_GATEWAY_DB_PORT=$MEDICAID_GATEWAY_DB_PORT
#ENV MEDICAID_GATEWAY_DB_NAME=$MEDICAID_GATEWAY_DB_NAME
#ENV RABBITMQ_URL=$RABBITMQ_URL

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5 --without development test 
#RUN rm -f /medicaid_gateway/config/master.key && rm -f /medicaid_gateway/config/credentials.yml.enc

#CMD ["./entrypoints/docker-entrypoint.sh"]


########################
### web/nginx config ###
######################## 

FROM nginx:1.17.6-alpine as web

RUN mkdir /medicaid_gateway

# copy assets from the app build and nginx config
COPY --from=app /medicaid_gateway/public /medicaid_gateway/
COPY .docker/production/nginx.conf /etc/nginx/conf.d/medicaid_gateway.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf-bkp

