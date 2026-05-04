Terraform - S3 Backend

## Intro

- This terraform code creates a bucket to store Terraform state.
  - Note: this version of the lab no longer creates a DynamoDB table for lock (not needed since Terraform version 1.11)
  - Later, in the `backend` block we will now use the flag `use_lockfile = true` (defaults to `false`).  We will no longer reference a DynamoDB table for the lock.

- We use the following convention to name the resources:

    - bucket `terraform-course-<acct-id>-state` e.g. `terraform-course-123456789012-state`

- Buckets must have unique numbers across all AWS.   We use <acct-id> so that bucket names are unique -- otherwise each student acccount would create the same bucket name.  

- NOTE:  Ideally projects and environments would have dedicated state buckets.  The bucket  and dynamoDB table names we use in these labs are not too realistic (too "static"), but we chose to make it that way to simplify permission management of the students.   We put the values in local variables to facilitate changing if desired.


## How to create the state bucket and dynamoDB lock table
- terraform init, validate, plan, apply

## Assorted Notes
### 1. Why iam_principal_info in outputs?

- We explicitly list in the outputs the IAM principal identity to remind us to tighten further the security of the state bucket, perhaps with a bucket policy 

```
iam_principal_info = {
  "account_id" = "012345678912"
  "arn" = "arn:aws:iam::012345678912:user/sso-student"
  "id" = "012345678912"
  "user_id" = "AIDATSOPQRSTYOGP7LXWL"
}
```

### 2. s3 bucket lifecycle 

- `prevent_destroy = true` prevents the bucket being destroyed by Terraform.  We want to prevent accidentally deleting the remote backend bucket with a careless `terraform destroy`.  
This flag  does not prevent destruction outside of Terraform.
- We disabled this part of the code inside the bucket resource while tuning the config and enabled it once satisifed all was as we wanted.

```
    lifecycle {
      prevent_destroy = true
    }
```
