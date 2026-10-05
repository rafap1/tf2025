special_port   = "6666"
instance_names = ["dep1", "dep3", "dep4"]

ec2_instances = {
  web = {
    instance_type = "t3.micro"
    disk_size     = 20
    disk_type     = "gp3"
  }
  app = {
    instance_type = "t3.small"
    disk_size     = 50
    disk_type     = "gp3"
  }
  db = {
    instance_type = "t3.medium"
    disk_size     = 100
    disk_type     = "io1"
  }
}

