# setup docker image config
cp config/mongoid.yml config/mongoid.yml.tmp
cp config/environments/production.rb config/environments/production.rb.tmp
cp config/credentials.yml.enc config/credentials.yml.enc.tmp

cp .docker/config/mongoid.yml config/
cp .docker/config/production.rb config/environments/
cp .docker/config/unicorn.rb config/
cp .docker/config/credentials.yml.enc config/
cp .docker/config/master.key config/

docker build --build-arg BUNDLER_VERSION_OVERRIDE='2.2.14' \
             --build-arg NODE_MAJOR='20' \
             --build-arg YARN_VERSION='1.22.4' \
             --build-arg RABBITMQ_URL_EVENT_SOURCE="amqp://rabbitmq:5672" \
             --build-arg MEDICAID_GATEWAY_DB_HOST='host.docker.internal' \
             --build-arg MEDICAID_GATEWAY_DB_PORT="27017" \
             --build-arg MEDICAID_GATEWAY_DB_NAME="medicaid_gateway_production" \
             --build-arg RABBITMQ_URL="amqp://rabbitmq:5672" \
             --build-arg RABBITMQ_HOST="amqp://rabbitmq" \
             --build-arg RABBITMQ_PORT="5672" \
             --build-arg RABBITMQ_VHOST="event_source" \
	     --network="host" \
	     -f .docker/production/Dockerfile --target app -t $2:$1 .
docker push $2:$1

mv config/mongoid.yml.tmp config/mongoid.yml
mv config/environments/production.rb.tmp config/environments/production.rb
mv config/credentials.yml.enc.tmp config/credentials.yml.enc
rm config/unicorn.rb
rm config/master.key
