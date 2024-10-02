#!/bin/bash

# build all images, tagging each with the "latest" tag and a unique tag based on the git commit hash
#  (SHA env variable set in travis config)
docker build -t dfi3g/multi-client:latest -t dfi3g/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t dfi3g/multi-server:latest -t dfi3g/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t dfi3g/multi-worker:latest -t dfi3g/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push all images to Docker Hub (should already be signed in via Travis pipeline)
docker push dfi3g/multi-client --all-tags
docker push dfi3g/multi-server --all-tags
docker push dfi3g/multi-worker --all-tags

# Previously you'd need to push each tag separately
# docker push dfi3g/multi-client:latest
# docker push dfi3g/multi-server:latest
# docker push dfi3g/multi-worker:latest
# docker push dfi3g/multi-client:$SHA
# docker push dfi3g/multi-server:$SHA
# docker push dfi3g/multi-worker:$SHA

# apply all k8s configs (this works because we set up kubectl for gcloud in the Travis yaml)
kubectl apply -f /k8s

kubectl set image deployments/client-deployment client=dfi3g/multi-client:$SHA
kubectl set image deployments/server-deployment server=dfi3g/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=dfi3g/multi-worker:$SHA