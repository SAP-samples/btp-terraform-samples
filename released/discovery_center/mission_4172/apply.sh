#!/bin/sh

cd step1

terraform init
terraform apply -var-file='../samples.tfvars' -auto-approve
terraform output > ../step2/step1vars.tfvars

cd ../step2

terraform init
terraform apply -var-file=step1vars.tfvars -var-file='../samples.tfvars' -auto-approve

cd ..