.PHONY: pipeline
pipeline: upload
	$(eval ENVIRONMENT := $(shell bash -c 'read -e -p "Environment [dev, test, prod]: " var; echo $$var'))
	$(eval REPOSITORY_NAME := $(shell bash -c 'read -e -p "Repo Name: " var; echo $$var'))
	-@unset AWS_DEFAULT_REGION; \
	aws configure --profile $(REPOSITORY_NAME)-$(ENVIRONMENT); \
	aws cloudformation create-stack \
		--profile $(REPOSITORY_NAME)-$(ENVIRONMENT) \
		--stack-name Pipeline$(REPOSITORY_NAME) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--template-body file://pipeline.yml \
		--parameters \
		  ParameterKey=Environment,ParameterValue=$(ENVIRONMENT) \
		  ParameterKey=StackName,ParameterValue=$(STACK_NAME) \
		  ParameterKey=RepositoryName,ParameterValue=$(REPOSITORY_NAME)


.PHONY: update_pipeline
update_pipeline: upload
	$(eval ENVIRONMENT := $(shell bash -c 'read -e -p "Environment [dev, test, prod]: " var; echo $$var'))
	-@unset AWS_DEFAULT_REGION; \
	aws configure --profile $(REPOSITORY_NAME)-$(ENVIRONMENT); \
	aws cloudformation update-stack \
		--profile $(REPOSITORY_NAME)-$(ENVIRONMENT) \
		--stack-name Pipeline$(REPOSITORY_NAME) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--template-body file://pipeline.yml \
		--parameters \
		  ParameterKey=Environment,ParameterValue=$(ENVIRONMENT) \
		  ParameterKey=StackName,ParameterValue=$(STACK_NAME) \
		  ParameterKey=RepositoryName,ParameterValue=$(REPOSITORY_NAME)

