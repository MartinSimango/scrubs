### API ###

run-api:
	cargo run --manifest-path=api/Cargo.toml


### DOCKER ###

docker-build-api:
	docker build -t scrubs-api:latest -f build/api/Dockerfile api/



### KUBERNETES ###

k8s-flux-bootstrap-system:
	flux bootstrap github \
 		--token-auth \
  	--owner=MartinSimango \
  	--repository=scrubs \
  	--branch=main \
  	--path=k8s/system \
  	--personal

k8s-flux-bootstrap-prod:
	flux bootstrap github \
 		--token-auth \
  	--owner=MartinSimango \
  	--repository=scrubs \
  	--branch=main \
  	--path=k8s/prod \
  	--personal



k8s-apply-dev:
	kubectl apply -k k8s/dev/


k8s-create-docker-sealed-secret:
	scripts/create-docker-sealed-secret.sh
