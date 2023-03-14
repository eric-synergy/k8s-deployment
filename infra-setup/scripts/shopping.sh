##deploy shopping website 
git clone https://github.com/microservices-demo/microservices-demo.git
cd microservices-demo/deploy/kubernetes
kubectl apply -f complete-demo.yaml
### run application using browser
## http://10.110.10.86:30001/
