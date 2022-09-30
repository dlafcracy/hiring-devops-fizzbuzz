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

To the best of your current knowledge, refactor the code so that it aligns with best practices in software design and code lifecycle.

## Task 2: Observability improvements

To the best of your current knowledge, instrument the code so that it becomes observable. You may assume use of any monitoring tools you are familiar with.

## Task 3: Configurability improvements

To the best of your current knowledge, refactor the code so that the service becomes configurable for a cloud-native deployment.

## Task 4: Containerisation

Implement a Docker image for this service using any best practices in containerisation you know of.

## Task 5: Orchestration for local use

Create a Docker Compose manifest such that 3 instances of this service is spun up with each service performing the healthcheck on the next service. For example, `A` should check if `B` is alive, `B` should check if `C` is alive, `C` should check if `A` is alive.

## Task 6: Orchestration for deployment

Create a Helm chart that deploys the previous workload orchestration into Kubernetes. You can spin up a Kubernetes cluster locally using [the `kind` CLI tool](https://kind.sigs.k8s.io/):

```
kind create cluster;
```

## Task 7: Automation implementation

Developers may not always be familiar with build processes. Implement a way (eg. Makefile, shell scripts, etc) for developers to easily build and run this service locally.

## Task 8: Documentation

Replace the content of this `README.md` with relevant documentation on how to build/run/test/deploy/release this service.
