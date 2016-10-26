NAME=amazon-linux/consul:build
BUCKET=dist.aws.fasten.com
AWS_DEFAULT_PROFILE=fasten.us
AWS_DEFAULT_REGION=us-east-1

all: build run list upload

build:
	@docker build -t $(NAME) --rm=true .
run:
	@docker run -v $(PWD)/RPMS:/root/rpmbuild/RPMS -v $(PWD)/SRPMS:/root/rpmbuild/SRPMS --rm=true $(NAME)
list:
	@find . -name \*.rpm
upload:
	find . -name \*.rpm | xargs -I{} aws --profile $(AWS_DEFAULT_PROFILE) --region $(AWS_DEFAULT_REGION) s3 cp {} s3://$(BUCKET)
