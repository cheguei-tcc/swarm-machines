locals {
  manager = join("\n", [module.ec2_instance_manager.public_ip])
  workers = join("\n", [for ec2 in module.ec2_instance_worker_nodes : ec2.public_ip])

  hosts = <<HOSTS
[manager]
${local.manager}

[worker]
${local.workers}

[all]
[all:vars]
ansible_ssh_private_key_file=swarm-machines.pem
ansible_user=ec2-user
HOSTS
}

resource "local_file" "hosts" {
  filename = "../ansible/hosts"
  content  = local.hosts
}