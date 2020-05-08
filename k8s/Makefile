cluster-setup:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com && \
		helm install --namespace kube-system stable/sealed-secrets --generate-name

apply-app-manifests:
	kubectl create -f app/secrets.yaml && \
		kubectl create -f app/sealed-secrets.yaml && \
		kubectl create -f app/configmap.yaml && \
		kubectl create -f app/service.yaml && \
		kubectl create -f app/deployment.yaml && \
		kubectl create -f app/ingress.yaml

apply-redis-manifests:
	kubectl create -f redis/secrets.yaml && \
		kubectl create -f redis/sealed-secrets.yaml && \
		kubectl create -f redis/configmap.yaml && \
		kubectl create -f redis/service.yaml && \
		kubectl create -f redis/deployment.yaml

apply-postgresql-manifests:
	kubectl create -f postgresql/secrets.yaml && \
		kubectl create -f postgresql/sealed-secrets.yaml && \
		kubectl create -f postgresql/pv.yaml && \
		kubectl create -f postgresql/service.yaml && \
		kubectl create -f postgresql/deployment.yaml

apply-manifests:
	$(MAKE) apply-redis-manifests && \
		$(MAKE) apply-postgresql-manifests && \
		$(MAKE) apply-app-manifests

inspect-redis-components:
	echo "~REDIS~ \n" && echo secret && kubectl get secret redis && echo "\n" && \
		echo sealedsecret && kubectl get sealedsecret redis && echo "\n" && \
		echo configmap && kubectl get configmap redis && echo "\n" && \
		echo service && kubectl get service redis && echo "\n" && \
		echo deployment && kubectl get deployment redis

inspect-postgresql-components:
	echo "~POSTGRESQL~ \n" && echo secret && kubectl get secret postgresql && echo "\n" && \
		echo sealedsecret && kubectl get sealedsecret postgresql && echo "\n" && \
		echo pv && kubectl get pv postgresql && echo "\n" && \
		echo pvc && kubectl get pvc postgresql && echo "\n" && \
		echo service && kubectl get service postgresql && echo "\n" && \
		echo deployment && kubectl get deployment postgresql

inspect-app-components:
	echo "~BOILERPLATE~ \n" && echo secret && kubectl get secret boilerplate && echo "\n" && \
		echo sealedsecret && kubectl get sealedsecret boilerplate && echo "\n" && \
		echo configmap && kubectl get configmap boilerplate && echo "\n" && \
		echo service && kubectl get service boilerplate && echo "\n" && \
		echo ingress && kubectl get ingress boilerplate && echo "\n" && \
		echo deployment && kubectl get deployment boilerplate

inspect-components:
	$(MAKE) inspect-redis-components && \
		$(MAKE) inspect-postgresql-components && \
		$(MAKE) inspect-app-components

get-redis-pods:
	kubectl get pods | grep boilerplate

get-app-pods:
	kubectl get pods | grep boilerplate

get-pods:
	$(MAKE) get-redis-pods && $(MAKE) get-app-pods

forward-service:
	kubectl port-forward svc/boilerplate 4000:80
