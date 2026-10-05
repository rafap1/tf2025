profile    = "sso-student"
project    = "mdr"
lab_number = "lab06"
region     = "eu-south-2"


ec2_instances = {
  "web-01" = {
    instance_type = "t3.nano"
    disk_size_gb  = 10
    disk_type     = "gp2"
    cost_center   = "11111"
  }
  "web-02" = {
    instance_type = "t3.nano"
    disk_size_gb  = 12
    disk_type     = "gp3"
    cost_center   = "11111"
  }
  "app-01" = {
    instance_type = "t3.micro"
    disk_size_gb  = 14
    disk_type     = "gp3"
    cost_center   = "22222"
  }
  "app-02" = {
    instance_type = "t3.micro"
    disk_size_gb  = 8
    disk_type     = "gp3"
    cost_center   = "22222"
  }
}