### API ###

run-api:
	cargo run --manifest-path=api/Cargo.toml


### DOCKER ###

docker-build-api:
	docker buildx build --platform linux/arm64,linux/amd64 -t martinsimango/scrubs-api:latest -f build/api/Dockerfile api/ --push

docker-build-update-dns-push: # TODO the multi build should be part of CI/CD and locally just build image for host architecture
	docker buildx build --platform linux/arm64,linux/amd64  -t martinsimango/update-dns:latest -f build/update-dns/Dockerfile . --push
docker-build-update-dns:
	docker build  -t martinsimango/update-dns:latest -f build/update-dns/Dockerfile . 

### KUBERNETES ###

k8s-flux-bootstrap:
	flux bootstrap github \
 		--token-auth \
  	--owner=MartinSimango \
  	--repository=scrubs \
  	--branch=main \
  	--path=k8s/system \
  	--personal

k8s-apply-prod:
	kubectl apply -k k8s/prod/

k8s-apply-dev:
	kubectl apply -k k8s/dev/


k8s-create-docker-sealed-secret:
	scripts/create-docker-sealed-secret.sh
