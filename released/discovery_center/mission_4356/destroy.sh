#!/bin/sh

cd step-2

terraform destroy -var-file=step1vars.tfvars -var-file='../samples.tfvars' -auto-approve
rm samples.tfvars

cd ../step-1

terraform destroy -var-file='../samples.tfvars' -auto-approve

cd ..