profile     = "sso-student"
project     = "mdr"
company     = "lumon"
environment = "dev"
lab_number  = "10"

lifecycle_rules = {
  logs = {
    prefix           = "logs/"
    enabled          = true
    transition_days  = 30
    transition_class = "STANDARD_IA"
    expiration_days  = 365 
  }
  archives = {
    prefix           = "archives/"
    enabled          = true
    transition_days  = 10 
    transition_class = "DEEP_ARCHIVE"
    expiration_days  = 3650 ## ten years
  }
  temp = {
    prefix           = "projects/"
    enabled          = true
    transition_days  = 60
    transition_class = "STANDARD_IA"
    expiration_days  = 1000 
  }
}
