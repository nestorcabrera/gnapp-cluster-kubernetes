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
     #--set rbac.create=true \
     #--set controller.service.annotations."kubernetes.io/ingress.global-static-ip-name"="test-dev" \
     #--set controller.service.loadBalancerIP=34.107.141.150 \

sleep 60

helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v1.5.3 \
    --set installCRDs=true

kubectl apply -f ../common/

helm upgrade --install gitlab gitlab/gitlab \
    --timeout 600s \
    --set gitlab-runner.runners.privileged=true \
    --set nginx-ingress.enabled=false \
    --set global.ingress.class=nginx \
    --set certmanager.install=false \
    --set global.ingress.configureCertmanager=false \
    --set global.hosts.domain=gnapp.dev.gasneiva.com \
    --set global.ingress.tls.secretName=gitlab.gnapp.dev.gasneiva.com-tls \
    --set registry.ingress.tls.secretName=registry.gnapp.dev.gasneiva.com-tls \
    --version 5.2.1 \
    --namespace gitlab
    #--set global.hosts.domain=git.dev.gasneiva.com  
    #--set global.hosts.externalIP=35.201.72.51 \
    #--set certmanager-issuer.email=nestorcabrera@gasneiva.com \

sleep 60

kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

helm upgrade --install app-test ../app-test/

helm upgrade --install sample ../sample/