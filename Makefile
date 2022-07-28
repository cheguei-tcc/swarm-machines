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

aws-terraform-apply-ci:
	cd aws && terraform apply -auto-approve -input=false && cd ..

aws-ansible-playbook-ci:
	echo ${{ secrets.SWARM_MACHINES_KEY }} | base64 -d > ansible/swarm-machines.pem
	&& chmod 400 ansible/swarm-machines.pem
	&& cd ansible
	&& ansible-playbook main.yaml
