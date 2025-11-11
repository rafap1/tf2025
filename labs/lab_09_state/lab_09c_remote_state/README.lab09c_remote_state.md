Testing S3 State

This terraform code creates some resources and stores the state in a bucket we have created in "create-state-bucket"

## Convention for state bucket name and state file keys
- We use the following convention to name the resources:

    - bucket `terraform-course-<acct-id>-state` e.g. `terraform-course-123456789012-state`

- Buckets must have unique numbers across all AWS.   We use <acct-id> so that bucket names are unique -- otherwise each student acccount would create the same bucket name.  
- NOTE:  Starting with Terraform v.
- NOTE:  Ideally projects and environments could have dedicated state buckets.  The bucket  and dynamoDB table names we use in these labs are not too realistic (too "static"), but we chose to make it that way to simplify permission management of the students.   We put the values in local variables to facilitate changing if desired.

## State file "keys" 
- In this lab we use the following convention
- One bucket for multiple projects (this is indeed debatable)
- for each project (e.g. 'mdr') we have multiple applications (example-01, example-02)
- The S3 key for the state file for app 'example-01' in project 'mdr' will be:  /mdr/example-01/terraform.tfstate`

- NOTE about S3 terminology:
    -The term "key" in S3 refers to the "path" to a given object.  For example if we store an object in a given bucket
    - bucket: `terraform-course-123456789012-state`
    - "path": `/mdr/example-01/terraform.tfstate`
        - the key of the object is: `mdr/example-01/terraform.tfstate`
        - the full S3 URI of the object is `s3://terraform-course-123456789012-state/mdr/example-01/terraform.tfstate`

## Exploring the s3 bucket
- Example to explore the bucket with the aws CLI
IMPORTANT : substitute your account number (12 digits) for xxxxxxxxxxxxx

```
ACCOUNT_NUMBER=123456789012
REGION=eu-south-2
PROFILE=sso-student
aws s3 ls s3://terraform-course-$ACCOUNT_NUMBER-state --profile $PROFILE --region $REGION --recursive

2025-06-11 23:23:22        181 mdr/example-01/terraform.tfstate
2025-06-11 23:45:04      15647 mdr/example-02/terraform.tfstate
```
- Example exploring the object versions - we use  `aws s3api` instead of `aws s3`
- We enable versioning when creating the bucket to make sure we preserve prior versions (you can use lifecycle policies in the bucket to manage the number of versions preserved, and how older versions are deleted)
```
ACCOUNT_NUMBER=123456789012
REGION=eu-south-2
PROFILE=sso-student
aws s3api list-object-versions \
  --bucket terraform-course-$ACCOUNT_NUMBER-state \
  --prefix mdr/example-01/terraform.tfstate  \
  --query 'Versions[].{Key:Key,VersionId:VersionId,LastModified:LastModified,IsLatest:IsLatest}' \
  --profile $PROFILE \
  --region $REGION \
  --output table


-------------------------------------------------------------------------------------------------------------------
|                                               ListObjectVersions                                                |
+---------+------------------------------------+-----------------------------+------------------------------------+
|IsLatest |                Key                 |        LastModified         |             VersionId              |
+---------+------------------------------------+-----------------------------+------------------------------------+
|  True   |  mdr/example-01/terraform.tfstate  |  2025-06-11T21:23:22+00:00  |  pl17CAU0IS6SZJCt0QSErberMBZVxBsl  |
|  False  |  mdr/example-01/terraform.tfstate  |  2025-06-11T21:23:21+00:00  |  GMa8_6w02nLaf77D3KfYwMHzsFeKzPoy  |
|  False  |  mdr/example-01/terraform.tfstate  |  2025-06-11T21:19:27+00:00  |  OtsIm0TIQNsUasoz8zCN8fwcd6Xzu.my  |
|  False  |  mdr/example-01/terraform.tfstate  |  2025-06-11T21:18:22+00:00  |  GXUvunp4ZguYwTKyopI0NgPUedk7mzC.  |
|  False  |  mdr/example-01/terraform.tfstate  |  2025-06-11T20:31:44+00:00  |  _Ya6VFqIfNZmibCILW8oV3U9R4ZfO_Q3  |
+---------+------------------------------------+-----------------------------+------------------------------------+
```
## Verifying state file lock
- Note: We no longer use dynamodb to create a file lock.  The `s3 backend` implementation automatically creates a file lock
- A simple way to test state locking is to use `terraform console`.  Running the console locks the state file.

- To test it - move to directory `1.use-state-s3-example-app-01`
  - Open two terminal screens
    - In the first screen run `terraform console`
    - In the second screen:
      - Repeat the command above to see the contents of the S3 bucket (or open the AWS Console and explore the bucket in S3). You should see a new file called `terraform.tfstate.tflock`
      - try `terraform plan` - You should see an error with terraform containing that it could not acquire the state lock.

```
terraform plan
╷
│ Error: Error acquiring the state lock
│ 
│ Error message: operation error S3: PutObject, https response error StatusCode: 412, RequestID: 948EBQJR5869GHPD, HostID:
│ pcNDMyg3KZlNg5OL0jqlXAFXAh0+VzHjRQ1X9MuyXDz1+mAtyd3WLnMFd1UM3rasvf+bnP7dctQGejNz+6qKL9lDV2msYjAQ, api error PreconditionFailed:
│ At least one of the pre-conditions you specified did not hold
│ Lock Info:
│   ID:        ed405100-6481-eef8-98f5-d273d88b74a2
│   Path:      terraform-course-761528455679-state/mdr/example-01/terraform.tfstate
│   Operation: OperationTypeInvalid
│   Who:       rafap@rafap.local
│   Version:   1.13.4
│   Created:   2025-11-11 11:30:53.433457 +0000 UTC
│   Info:      
│ 
│ 
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.
```
- Continue testing...
      - Try also `terraform validate` - Notice you do not get a lock error, since `validate` does not attempt to obtain a lock on the state file, since it only does local checking of the terraform files.
      - Go back to the first screen and stop `terraform console` (Ctrl-C or Ctrl-D)
      - Then go to the second screen and run again `terraform plan` - you should not find an error.
      - Verify again the contents of the bucket.  File `terraform.tfstate.tflock` is no longer present.


## Lab 3.use-state-s3-example-app-03-hcl
- This lab is very similar to Labs 1 and 2, except that the common configuration for the backend is stored in a file that we call `backend.hcl`.  
- We decided to place this file in the parent directory since presumably it will be used by several projects.  Thus we run `terraform init` with the `-backend-config` flag  as follows.

```
terraform init -backend-config=../backend.hcl               
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.99.1

Terraform has been successfully initialized!

(...)
```