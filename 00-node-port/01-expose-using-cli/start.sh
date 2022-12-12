# Run a Hello World application in your cluster: Create the application Deployment using the file above:
# The preceding command creates a Deployment and an associated ReplicaSet. The ReplicaSet has two Pods each of which runs the Hello World application.
kubectl apply -f https://k8s.io/examples/service/access/hello-application.yaml

# # Display information about the Deployment:
# kubectl get deployments hello-world
# kubectl describe deployments hello-world

# # Display information about your ReplicaSet objects:
# kubectl get replicasets
# kubectl describe replicasets

# Create a Service object that exposes the deployment:
kubectl expose deployment hello-world --type=NodePort --name=example-service

# Display information about the Service:
# kubectl describe services example-service
kubectl get service | grep example-service

# # for Minikube users
# kubectl cluster-info

curl localhost:30959

# kubectl delete services example-service
# kubectl delete deployment hello-world