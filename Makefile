aws-terraform-format:
	cd aws && terraform fmt && cd ..

aws-terraform-plan:
	cd aws && terraform plan && cd ..

aws-terraform-apply:
	cd aws && terraform apply && cd ..

aws-terraform-destroy:
	cd aws && terraform destroy && cd ..

aws-terraform-init:
	cd aws && terraform init && cd ..

aws-terraform-output:
	cd aws && terraform output && cd ..

aws-ansible-playbook:
	cd ansible && ansible-playbook main.yaml && cd ..
