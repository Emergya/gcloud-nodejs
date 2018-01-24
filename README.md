# Build

NODE_VERSION=8.9.4

docker build --build-arg NODE_VERSION=$NODE_VERSION -t emergya/gcloud-nodejs:$NODE_VERSION .
