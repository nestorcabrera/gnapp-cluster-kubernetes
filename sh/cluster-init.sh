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
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
     --namespace ingress-nginx \
     --set controller.replicaCount=2 \
     --version 4.0.1

helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v1.0.1 \
    --set installCRDs=true

helm upgrade --install gitlab gitlab/gitlab \
    --timeout 600s \
    --set certmanager-issuer.email=nestorcabrera@gasneiva.com \
    --set gitlab-runner.runners.privileged=true \
    --version 5.2.1 \
    --namespace gitlab

kubectl apply -f ../common/

helm upgrade --install app-test ../app-test/