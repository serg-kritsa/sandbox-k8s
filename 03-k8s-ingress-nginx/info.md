
## imagePullPolicy to the pod
If your pods are showing ErrImagePull, ErrImageNeverPull, or ImagePullBackOff errors after running kubectl apply, the simplest solution is to provide an imagePullPolicy to the pod.

* First, run `kubectl delete -f infra/k8s/`
* Then, update your pod manifest:
spec:
containers:
    - name: posts
    image: cygnet/posts:0.0.1
    imagePullPolicy: Never
* Then, run `kubectl apply -f infra/k8s/`

## Useful commands
kubectl get pods
kubectl exec -it pod_name cmd_in_container 
kubectl logs pod_name 
kubectl delete pod pod_name 
kubectl apply -f config_file_name
kubectl describe pod pod_name 

## A time-saving aliase
code ~/.bashrc
alias k="kubectl"