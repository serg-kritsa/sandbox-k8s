kubectl.exe apply -f src/hello-application-V1.yaml 

kubectl get service | grep example-service
# curl localhost:<NodePort>

kubectl.exe delete -f src/hello-application-V1.yaml 