#!/bin/bash

# basic help menu
function help {
  echo "This is quick help on dev.sh script."
  echo "These are the options available."
  echo "  -q : quick prerequisites check "
  echo "  -b : build container image"
  echo "  -d : quick docker cleanup"
  echo "  -s : start single docker container"
  echo "  -c : start containers with docker-compose"
  echo "  -u : quick up patch version"
  echo "  -k : start containers in kind/kubernetes"
  echo "  -t : terminate containers and kind/kubernetes"
}

if [ "$#" -ne 1 ]; then
    echo "Missing arguments."
    help
    exit 0
fi

# check basic commands / tools required for the setup
function check_prerequisites {
  list_of_binaries=(
    "docker"
    "docker-compose"
    "npm"
    "kind"
    "kubectl"
    "node"
    "yq"
    "helm"
  )
  for i in ${list_of_binaries[@]}
  do
    if [[ -z "$(which $i)" ]];
    then
      echo "\"$i\" command is not available. Please consider checking installation or setup of \"$i\"."
    fi
  done

  # validate nodejs version
  NODE_VERSION=$(node -v)
  if [[ ! "$NODE_VERSION" =~ v16\. ]];
  then
    echo "Found unexpected NodeJS version $NODE_VERSION used for this project."
  fi

  # end of validation message
  echo "Prerequisites check done."
}

# tag on to npm scripts to auto up patch version with npm available
function auto_up_version {
  npm run uppatchversion
}

# build docker image with image name as package name and image tag tied to app version
function docker_build_image {
  IMAGE_NAME=$(npx -c 'echo $npm_package_name')
  IMAGE_TAG=$(npx -c 'echo $npm_package_version')
  docker build -t $IMAGE_NAME:$IMAGE_TAG .
}

# quick dirty force cleanup of tangling docker resources
function docker_quick_cleanup {
  IMAGE_NAME=$(npx -c 'echo $npm_package_name')
  docker stop "local-${IMAGE_NAME}" || docker-compose down
  docker system prune -f
}

# start single container
function docker_single_start {
  IMAGE_NAME=$(npx -c 'echo $npm_package_name')
  IMAGE_TAG=$(npx -c 'echo $npm_package_version')
  IMAGE_CHECK=$(docker images -f "reference=${IMAGE_NAME}:${IMAGE_TAG}" --format "{{.Repository}}:{{.Tag}}")
  if [[ -z "${IMAGE_CHECK}" ]];
  then
    echo "image ${IMAGE_NAME}:${IMAGE_TAG} has not been built yet. Please do docker build image with -b."
  else
    docker run --name "local-${IMAGE_NAME}" -d --restart=unless-stopped --expose 3000 ${IMAGE_NAME}:${IMAGE_TAG}
    docker wait "local-${IMAGE_NAME}"
    echo "single docker container is up and running, and listening at port 3000."
  fi
}

# start multiple containers with docker-compose
function docker_compose_start {
  IMAGE_NAME=$(npx -c 'echo $npm_package_name')
  IMAGE_TAG=$(npx -c 'echo $npm_package_version')
  IMAGE="${IMAGE_NAME}:${IMAGE_TAG}" yq -i '.["services"][]["image"] = strenv(IMAGE)' docker-compose.yml
  IMAGE_CHECK=$(docker images -f "reference=${IMAGE_NAME}:${IMAGE_TAG}" --format "{{.Repository}}:{{.Tag}}")
  if [[ -z "${IMAGE_CHECK}" ]];
  then
    echo "image ${IMAGE_NAME}:${IMAGE_TAG} has not been built yet. Please do docker build image with -b."
  else
    docker-compose up -d
  fi
}

# start containers in kind/kubernetes using helm
function kubernetes_start {
  IMAGE_NAME=$(npx -c 'echo $npm_package_name')
  IMAGE_TAG=$(npx -c 'echo $npm_package_version')
  yq -i '.["appVersion"] = strenv(IMAGE_TAG)' helm/fizzbuzz/Chart.yaml
  yq -i '.["image"]["repository"] = strenv(IMAGE_TAG)' helm/fizzbuzz/values.yaml 
  IMAGE_CHECK=$(docker images -f "reference=${IMAGE_NAME}:${IMAGE_TAG}" --format "{{.Repository}}:{{.Tag}}")
  if [[ -z "${IMAGE_CHECK}" ]];
  then
    echo "image ${IMAGE_NAME}:${IMAGE_TAG} has not been built yet. Please do docker build image with -b."
  else
    # check kind cluster status and create as needed
    if [[ -z "$(kind get clusters -q)" ]];
    then
      kind create cluster
    fi
    # push container image into kind
    kind load docker-image "${IMAGE_NAME}:${IMAGE_TAG}"
    # check helm installation
    if [[ -z "$(helm list | grep localfizzbuzz)" ]]
    then 
      helm install localfizzbuzz helm/fizzbuzz/
    else
      helm upgrade localfizzbuzz fizzbuzz/
    fi
  fi
}

# cleanup containers and kind/kubernetes
function kubernetes_kill {
  if [[ "$(kind get clusters -q)" ]];
  then
    kind delete cluster
  fi
}

while getopts "qbdsuck" option; do
case ${option} in
  q ) 
    check_prerequisites
  ;;
  b )
    docker_build_image
  ;;
  d )
    docker_quick_cleanup
  ;;
  s )
    docker_single_start
  ;;
  u )
    auto_up_version
  ;;
  c )
    docker_compose_start
  ;;
  k )
    kubernetes_start
  ;;
  t )
    kubernetes_kill
  ;;
  \?)
    help
  ;;
esac
done
