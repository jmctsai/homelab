kubectl run nginx --image=nginx --port=80
kubectl expose pod nginx --type=LoadBalancer --port=80

kubectl get svc nginx

kubectl delete pod nginx
kubectl delete svc nginx

