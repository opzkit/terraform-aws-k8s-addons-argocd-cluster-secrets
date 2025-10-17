SHELL = /bin/bash
EXAMPLES = $(shell find ./examples/* -maxdepth 1 -type d -not -path '*/\.*')

export AWS_ACCESS_KEY_ID := test
export AWS_SECRET_ACCESS_KEY := test
export AWS_DEFAULT_REGION := us-east-1
export AWS_REGION := us-east-1
export AWS_ENDPOINT_URL := http://localhost:4566
.PHONY: examples
examples: $(addprefix example/,$(EXAMPLES))

.PHONY: example/%
example/%:
	@aws secretsmanager create-secret --name argocd/clusters/$*-1 --secret-string 'asd' --tags Key=a/tag,Value=dev Key=another/tag,Value=prod
	@aws secretsmanager create-secret --name argocd/clusters/$*-2 --secret-string 'asd' --tags Key=tag1,Value=stage Key=tag2,Value=invalid

	@echo "Processing example: $(notdir $*)"
	@terraform -chdir=$* init
	@terraform -chdir=$* validate

	@terraform -chdir=$* apply -auto-approve > $*/output

	@aws secretsmanager delete-secret --secret-id argocd/clusters/$*-1
	@aws secretsmanager delete-secret --secret-id argocd/clusters/$*-2

	$*/validate.sh $*/output
