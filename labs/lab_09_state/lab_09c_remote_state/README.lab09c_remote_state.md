Testing S3 State

This terraform code creates some resources and stores the state in a bucket we have created in "create-state-bucket"

## Convention for state bucket name and state file keys
- We use the following convention to name the resources:

    - bucket `terraform-course-<acct-id>-state` e.g. `terraform-course-123456789012-state`
    - dynamodb table `terraform-course-state-locks` e.g. 

- Buckets must have unique numbers across all AWS.   We use <acct-id> so that bucket names are unique -- otherwise each student acccount would create the same bucket name.  

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
ACCOUNT_NUMBER=761528455679
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
## Exploring the Dynamodb table with the CLI (scan)

- Scan of items in state table when there are no locks
- Yields one entry per "state-key" in the S3 bucket: in this case we have 2 for "example-01" and "example-02"

```
% aws dynamodb scan --table-name terraform-course-state-locks --profile sso-student

ConsumedCapacity: null
Count: 2
Items:
- Digest:
    S: 2e931012c24b8f6d6dcd9c8e06d21573
  LockID:
    S: terraform-course-761528455679-state/mdr/example-02/terraform.tfstate-md5
- Digest:
    S: a0e2789f86274b73fecbe0948179bc3f
  LockID:
    S: terraform-course-761528455679-state/mdr/example-01/terraform.tfstate-md5
ScannedCount: 2
```

- Now try to perform a terraform apply and scan the table again
- Scan of table when a lock is acquired.  In this case run `terraform destroy` in the example-02 directory and scan table while terraform waits for user confirmation ('yes')
- Note there is a new item in table associated with the path to the state of this application:
```
 % aws dynamodb scan --table-name terraform-course-state-locks --profile sso-student

ConsumedCapacity: null
Count: 3
Items:
- Info:
    S: '{"ID":"31ab505c-e46f-0f90-ce31-1f8a328f063a","Operation":"OperationTypeApply","Info":"","Who":"rafap@rafap.local","Version":"1.12.1","Created":"2025-06-11T21:45:42.296286Z","Path":"terraform-course-761528455679-state/mdr/example-02/terraform.tfstate"}'
  LockID:
    S: terraform-course-761528455679-state/mdr/example-02/terraform.tfstate
- Digest:
    S: 2e931012c24b8f6d6dcd9c8e06d21573
  LockID:
    S: terraform-course-761528455679-state/mdr/example-02/terraform.tfstate-md5
- Digest:
    S: a0e2789f86274b73fecbe0948179bc3f
  LockID:
    S: terraform-course-761528455679-state/mdr/example-01/terraform.tfstate-md5
ScannedCount: 3

```

## Using HCL backend configuration file

run init commands as follows:
```
terraform init -backend=true -backend-config=../backend.hcl
