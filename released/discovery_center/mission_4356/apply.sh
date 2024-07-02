#!/bin/sh

cd step-1

terraform init
terraform apply -var-file='../samples.tfvars' -auto-approve
terraform output > ../step-2/step1vars.tfvars

cd ../step-2

terraform init
terraform apply -var-file=step1vars.tfvars -var-file='../samples.tfvars' -auto-approve

cd ..