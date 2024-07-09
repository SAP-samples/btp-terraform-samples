#!/bin/sh

cd step2

terraform destroy -var-file=step1vars.tfvars -var-file='../samples.tfvars' -auto-approve
rm step1vars.tfvars

cd ../step1

terraform destroy -var-file='../samples.tfvars' -auto-approve

cd ..