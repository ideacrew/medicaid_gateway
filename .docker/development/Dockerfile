FROM ruby:2.7.2 AS medicaid_gateway

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
ENV PATH /medicaid_gateway/bin:$BUNDLE_BIN:$PATH

ARG BUNDLER_VERSION_OVERRIDE
RUN echo $BUNDLER_VERSION_OVERRIDE
RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -y tzdata build-essential nodejs vim && \
    apt-get autoremove -y && \
    gem install bundler:$BUNDLER_VERSION_OVERRIDE && \
    npm install --global yarn

COPY . $HOME

# Setting env up
ENV RAILS_ENV='development'
ENV NODE_ENV='development'

RUN bundle config set deployment 'true' && \
    bundle install