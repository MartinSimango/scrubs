clean:
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -rf plan.out
	rm -rf terraform.tfstate
init:
	terraform init

plan:
	terraform plan -out=plan.out

apply:
	terraform apply plan.out
	rm plan.out
