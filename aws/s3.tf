resource "aws_s3_object" "hosts" {
  bucket = "swarm-machines-tf"
  key    = "hosts"
  source = "../ansible/hosts"

  depends_on = [
    local_file.hosts
  ]
}