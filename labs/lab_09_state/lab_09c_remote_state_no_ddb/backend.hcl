# backend.hcl
bucket         = "terraform-course-761528455679-state"           
dynamodb_table = "terraform-course-state-locks"  
region         = "eu-south-2"
encrypt        = true
profile        = "sso-student"
