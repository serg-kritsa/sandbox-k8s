## Build Image
> cd posts
> docker build -t sergkritsa/posts:0.0.1 .

## Deploy Pod
> cd ../infra/k8s
> kubectl apply -f posts.yml
> kubectl get pods
> kubectl delete pod posts


## manual deployment. V0 - NodePort
> kubectl create deployment post --image=sergkritsa/posts:0.0.1 --port=4000
> kubectl expose deployment post --type=NodePort --name=post-np
> kubectl get all
> curl localhost:<3####>/posts

## manual deployment. V1
> kubectl create deployment posts --image=sergkritsa/posts:0.0.1 --port=4000
> kubectl expose deployment posts --name=posts-ip
> kubectl get all
> kubectl apply -f ingress-nginx.yaml
- C:\Windows\System32\drivers\etc\hosts         127.0.0.1 posts.com
curl posts.com/posts
> kubectl delete -f ingress-nginx.yaml
> kubectl delete deployment posts
> kubectl delete service posts-ip
> kubectl get all

## manual deployment. V2
kubectl create deployment demo --image=sergkritsa/posts:0.0.1 --port=4000
kubectl expose deployment demo
kubectl port-forward service/demo 8080:4000
http://localhost:8080/posts


kubectl delete deployment demo
kubectl delete service demo
kubectl get all
<!-- kubectl create service clusterip post-ip --tcp=4000:4000 
kubectl create service clusterip NAME --tcp=<port>:<targetPort>]  -->