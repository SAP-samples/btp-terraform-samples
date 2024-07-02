#!/bin/sh

cd step-1

terraform init
terraform apply -var-file=samples.tfvars -auto-approve
terraform output > ../step-2/samples.tfvars

cd ../step-2

terraform init
terraform apply -var-file=samples.tfvars -auto-approve

cd ..