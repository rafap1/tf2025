Terraform - S3 Backend

## Intro

- This terraform code creates a bucket to store Terraform state and a dynamodb table to serve as lock.

- We will make reference to this bucket and lock in the "provider block" of other labs

- We use the following convention to name the resources:

    - bucket `terraform-course-<acct-id>-state` e.g. `terraform-course-123456789012-state`
    - dynamodb table `terraform-course-state-locks` e.g. 

- Buckets must have unique numbers across all AWS.   We use <acct-id> so that bucket names are unique -- otherwise each student acccount would create the same bucket name.  

- NOTE:  Ideally projects and environments could have dedicated state buckets.  The bucket  and dynamoDB table names we use in these labs are not too realistic (too "static"), but we chose to make it that way to simplify permission management of the students.   We put the values in local variables to facilitate changing if desired.



## How to create the state bucket and dynamoDB lock table
- terraform init, validate, plan, apply

## Assorted Notes
### 1. Why iam_principal_info in outputs?

We explicitly list in the outputs the IAM principal identity to remind us to tighten further the security of the state bucket, perhaps with a bucket policy 

```
iam_principal_info = {
  "account_id" = "012345678912"
  "arn" = "arn:aws:iam::012345678912:user/sso-student"
  "id" = "012345678912"
  "user_id" = "AIDATSOPQRSTYOGP7LXWL"
}
```

### 2. s3 bucket lifecycle - what happens when we change

We disabled this part of the code inside the bucket resource while tuning the config and enabled it once satisifed all was as we wanted.

```
    lifecycle {
      prevent_destroy = true
    }
```
