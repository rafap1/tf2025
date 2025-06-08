profile      = "sso-student"
project      = "mdr"
lab_number   = "06"
special_port = "6666"

# sec_allowed_external = [ "2.0.0.0/8", "8.0.0.0/8" ]

ec2_instances = {
  "web-01" = {
    instance_type = "t3.nano"
    disk_size_gb  = 10
  }
  "web-02" = {
    instance_type = "t3.nano"
    disk_size_gb  = 12
  }
  "app-01" = {
    instance_type = "t3.micro"
    disk_size_gb  = 20
  }
}