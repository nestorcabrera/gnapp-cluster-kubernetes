#Select cluster
gcloud container clusters get-credentials gnapp --zone us-central1-a

#Create namespaces
kubectl create ns ingress-nginx
kubectl create ns cert-manager
kubectl create ns gitlab

#Add repos helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add gitlab http://charts.gitlab.io/
helm repo update

#Install repos
helm install ingress-nginx ingress-nginx/ingress-nginx \
     --namespace ingress-nginx \
     --set controller.replicaCount=2 \
     --version 4.0.1

helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v0.14.0 \
    --set installCRDs=true

helm install gitlab gitlab/gitlab \
     --version 5.2.1
     -n gitlab

kubectl apply -f ../common/deploy/

kubectl apply -f ../app-test/deploy/