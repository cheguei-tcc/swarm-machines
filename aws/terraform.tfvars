prefix            = "cheguei"
vpc_cidr_block    = "10.10.0.0/16"
instance_type     = "t3a.micro"
key_name          = "swarm-machines"
instances_workers = ["swarm-worker-0", "swarm-worker-1"]
dns_base_domain   = "cheguei.app"