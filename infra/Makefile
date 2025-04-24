ENV=dev
TF_BUCKET="scrubs-terraform-state-bucket"
TF_STATE_KEY="${ENV}.scrubs.terraform.tfstate"
REGION="eu-west-1"
  

clean:
	@rm -rf .terraform
	@rm -rf .terraform.lock.hcl
	@rm -rf plan.out
	@rm -rf terraform.tfstate

init:
	@terraform init -backend=true \
		-backend-config="bucket=${TF_BUCKET}" \
		-backend-config="key=${TF_STATE_KEY}" \
		-backend-config="region=${REGION}" \
		-backend-config="use_lockfile=true" \
		-backend-config="encrypt=true" 

plan:
	terraform plan -out=plan.out -var-file=params/${ENV}/params.tfvars 

apply:
	terraform apply plan.out
	rm plan.out
