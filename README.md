# DevOps Fizzbuzz

- [DevOps Fizzbuzz](#devops-fizzbuzz)
  - [Task 1: Architectural/lifecycle improvements](#task-1-architecturallifecycle-improvements)
  - [Task 2: Observability improvements](#task-2-observability-improvements)
  - [Task 3: Configurability improvements](#task-3-configurability-improvements)
  - [Task 4: Containerisation](#task-4-containerisation)
  - [Task 5: Orchestration for local use](#task-5-orchestration-for-local-use)
  - [Task 6: Orchestration for deployment](#task-6-orchestration-for-deployment)
  - [Task 7: Automation implementation](#task-7-automation-implementation)
  - [Task 8: Documentation](#task-8-documentation)

## Task 1: Architectural/lifecycle improvements

> To the best of your current knowledge, refactor the code so that it aligns with best practices in software design and code lifecycle.

#### Danny's comments:

- Add test.js to do testing on the endpoints ( Test build and repeat )
- Remove some default outputs from Express for security purposes
- Reduce code duplications with shared functions
- Potential moving to redis or some form of shared data storage to allow horizontal scaling ( saving data to memory is not persistent and not shared)
- Lock down major nodeJs version to be used to maintain consistency
- QoL improvement with nodemon for development


## Task 2: Observability improvements

> To the best of your current knowledge, instrument the code so that it becomes observable. You may assume use of any monitoring tools you are familiar with.

#### Danny's comments:

- using OpenTelemetry with auto instrumentation for quick tracing setup
- allow tracing send to console log or remote server


## Task 3: Configurability improvements

> To the best of your current knowledge, refactor the code so that the service becomes configurable for a cloud-native deployment.

#### Danny's comments:

- make use of env vars at runtime to determine healthcheck requirements ( target and interval )
- potentially changing listening port using env var

## Task 4: Containerisation

> Implement a Docker image for this service using any best practices in containerisation you know of.

#### Danny's comments:

- Dockerfile created, including curl os package for doing healthcheck when running as docker container
- enforce non-root user for security compliance

## Task 5: Orchestration for local use

> Create a Docker Compose manifest such that 3 instances of this service is spun up with each service performing the healthcheck on the next service. For example, `A` should check if `B` is alive, `B` should check if `C` is alive, `C` should check if `A` is alive.

#### Danny's comments:

- docker-compose.yml file created
- putting containers together in a specific docker network
- use env vars to change healthcheck for each containers while maintaining same image to be used across
- cap memory usage as memory is used to store data within individual containers

## Task 6: Orchestration for deployment

> Create a Helm chart that deploys the previous workload orchestration into Kubernetes. You can spin up a Kubernetes cluster locally using [the `kind` CLI tool](https://kind.sigs.k8s.io/):

#### Danny's comments:

- custom helm chart created, with TODO on output printing

## Task 7: Automation implementation

> Developers may not always be familiar with build processes. Implement a way (eg. Makefile, shell scripts, etc) for developers to easily build and run this service locally.

#### Danny's comments:

- dev.sh is prepared for some basic usage
- exec using the `bash dev.sh <argument>`

```
bash dev.sh 
Missing arguments.
This is quick help on dev.sh script.
These are the options available.
  -q : quick prerequisites check 
  -b : build container image
  -d : quick docker cleanup
  -s : start single docker container
  -c : start containers with docker-compose
  -u : quick up patch version
  -k : start containers in kind/kubernetes
  -t : terminate containers and kind/kubernetes
```

## Task 8: Documentation

> Replace the content of this `README.md` with relevant documentation on how to build/run/test/deploy/release this service.

#### Danny's comments:

- need to determine the actual container registry that will be used to store container image
- need to determine a central git server for storing code
- as much as possible, dev should do code changes only and raise pull requests to git repository
- setup git hooks for lint check
- setup pipeline upon pull request creation to run tests
- upon approval of pull requests and merging into main branch, pipeline perform auto version up
- pipeline perform code scanning 
- pipeline build container image and store in registry
- pipeline perform image scanning
- pipeline trigger deployment to specific environment using kubectl or docker-compose accordingly
- pipeline send notifications on deployment status (pass/fail)
- pipeline continue to do automated testing if available
- pipeline broadcast version of application that passed automated testing in specific environment
