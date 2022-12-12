
[youtube tutorial series sources](https://gitlab.com/nanuchi/youtube-tutorial-series)

## K8s architecture
## cluster set-up
master + Node 1 + Node 2 + Node 3 + ...

Master processes
- Api Server (cluster gateway/entrypoint) -> authorize/validate request -> ...other processes -> Pod
accept commands from kubectl
- Scheduler > Node Kubelet executes
manage where is available to run pod (on which worker node)
monitor load
- Controller manager > Node Kubelet executes
detect cluster state changes > try to recover as soon as possible
manage Pod restart
- etcd
monitor cluster health / available resources / cluster state changes

## k8s tools if Docker Desktop not used
### kubectl
[config k8s tools](https://kubernetes.io/docs/tasks/tools/)
`kubectl get all`
`kubectl get nodes`
### minikube - local k8s cluster for testing purposes
[minikube get started](https://minikube.sigs.k8s.io/docs/start/)
- one node k8s cluster that runs in local VirtualBox
- master and worker processes are both run on one node > docker pre-installed
tool is not very required, could be skipped

[service](https://kubernetes.io/docs/concepts/services-networking/service/)
[deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

Ingress
Service > Deployment > Pod
Service > StatefulSet > Pod
ConfigMap
Secret


kubectl create deployment nginx-depl --image=nginx  
kubectl get deployment
kubectl get pod
kubectl edit deployment nginx-depl              .yaml config in editor 
kubectl apply -f {filename.yaml}

## Create namespace V1
- kubectl get all -n test-namespace
No resources found in test-namespace namespace.
- kubectl apply -f {filename.yaml} --namespace=test-namespace
- kubectl get all -n test-namespace
## Create namespace 2
- add namespace props in config.yaml
.metatada.namespace: test-namespace

## kubens
- brew install kubectx
- kubens                            list of namespaces. active one is highlighted
- kubens test-namespace             switched active namespace
- kubens                            list of namespaces. active one is highlighted


## ingress controller pod
- separate proxy server
- public IP address & open port
- entrypoint to cluster 
## ingress controller:
- evavulates all rules
- manage redirections
- entrypoint to cluster 
many 3rd-party implementations
- k8s nginx ingress controller

## for Minikube users
- pre-installed parts
> kubectl get pod -n kube-system
    nginx-ingress-controller-<###..>-<###>
> kubectl get ns
    kubernates-dashboard
> kubectl get all -n kubernates-dashboard
- config host
> kubectl apply -f dashboard-ingress.yaml
> kubectl get ingress -n kubernates-dashboard --watch
    copy ADDRESS column value
- LINUX: add to /etc/host file 
- WINDOWS: add to C:\Windows\System32\drivers\etc\host file
> ADDRESS value  dashboard.com

## for Docker Desktop users
[nginx ingress controller installation guide](https://kubernetes.github.io/ingress-nginx/deploy/#docker-desktop)
> kubectl get nodes
> kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml


## store data
- Admins configure storage
-        create Persistent Volumes
- K8s Users claim Persistent Volumes using PersistentVolumeClaim

## Storage Class
Another abstraction level
- abstracts underlying storage provider
- parameters for that storage
- Storage Class requested by PersistentVolumeClaim

## hi-level overview
- Pod claims storage through PVC
- PVC requests storage from SC
- SC creates PV that meets the needs of the Claim 


StatefulSet stateful app:
- databases
- stores data (update)
Deployment for stateless app:
- don't keep record of state
- each request is completely new

Mysql replica pod issues if as Deployment:
- can't be created/deleted at same time
- can't be randomly addressed
- replica pods are not identical

Pod Identity
- sticky identity for each pod
- created from same specification, but not interchangeable
- persistent identifier across any re-scheduing

Scaling databese apps
Master - 1+ Slaves/Workers
Worker must know about each change to be up-to-date!
/data/vol/pv-0  Master
/data/vol/pv-1  Worker
/data/vol/pv-2  Worker
continious syncronization of Master - Slaves data flow 
/data/vol/pv-3  Worker
new Worker syncs data w/ previous Pod keep sync
if all Pods die, data still remains. new pod reattaches to Persistent Volume

Pod Identity
Deploment: random hash (eg. mysql-<hash>)
StatefulSet: fixed orderd names (eg. mysql-<ordinal number> i.e. mysql-0 mysql-1 mysql-2)
predictable pod name - mysql-0 
individual service name (eg. mysql-0.svc2 mysql-1.svc2 mysql-2.svc2)
fixed individual DNS name (eg. mysql-0.svc2)
when pod restarts:
- IP addr changes
- name & endpoint stays same 

need to do:
- configuring the cloning & data syncronizaion
- make remote storage available
- managing & back-up

Services provides:
- stable IP for pod
- loadbalaning
- loose coupling
- within & outside cluster
types:
- ClusterIP
- Headless
- NodePort
- LoadBalancer

see pod IP column 
> kubectl get pod -o wide



# client > Ingress > ClusterIP
## Ingress - Service binding
## binding by app name
- Ingress .spec.rules[N].http.paths[N].backend.service.name
- Service .metatada.name

## binding by port
- Ingress .spec.rules[N].http.paths[N].backend.service.port.number
- Service   .spec.ports[N].port

## Service - Pod binding
## binding by app name
it expains where to forward request
- Service     .spec.selector.app
- Deployment  .spec.template.metatada.labels.app

## binding by port
port. V0:
- Service       .spec.ports[N].targetPort
- Deployment    .spec.template.spec.containers[N].ports[N].containerPort

port. V1:
- Service       .spec.ports[N].targetPort: portName
- Deployment    .spec.template.spec.containers[N].ports[N].
    name: portName, containerPort: 80

## Service Endpoints
K8s:
- creates Endpoint object w/ the same name as Service
- keeps tracks (means updated when needed) of, which Pod are the members/endpoints of the Service
> kubectl get endpoints


Headless Service
================
for stateful apps like databases (psql, mongodb)
set ClusterIP to "None" - returns Pod IP address instead of Service one
- Service       .spec.ClusterIP: None

cleint needs to figure out IP address of each Pod
- Option 1 - API call to K8s API Server
[x] makes app too tied to K8s API
[x] inefficient
- Option 2 - DNS Lookup for Service 
returns single IP address (ClusterIP) 

> kubectl get svc
in CLUSTER-IP column will be None

NodePort Service
================
ClusterIP Service is accessable only from cluster itselt.
NodePort makes external traffic accessable via fixed port on each Worker Node
- Service       .spec.type: NodePort
- Service       .spec.ports[N].nodePort: 30000-32767

[x] keep port opened not secure

LoadBalancer Service
================
is extension of NodePort type
LoadBalancer has access to fixed nodePort on each Worker Node to redirect external traffic 
- Service       .spec.type: LoadBalancer
- Service       .spec.ports[N].nodePort: 30000-32767

client > LoadBalancer > NodePort > Worker > ClusterIP Service
client > Ingress > NodePort > Worker > ClusterIP Service


NodePort is not for production usecases