helm uninstall app-test
helm uninstall gitlab -n gitlab
helm uninstall cert-manager -n cert-manager
helm uninstall ingress-nginx -n ingress-nginx

kubectl delete ns gitlab
kubectl delete ns cert-manager
kubectl delete ns ingress-nginx