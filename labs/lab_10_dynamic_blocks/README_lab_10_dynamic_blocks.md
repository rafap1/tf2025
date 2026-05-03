# Lab 10 - Dynamic Blocks

NOTE: You can view this markdown file rendered in Visual Code with the following key combinations:

- Windows **Ctrl + Shift + V**
- Linux : **Ctrl + Shift + V**
- macOS:  **command  + shift +V**


## 1. Intro and objectives
- The main purpose of this lab is to explore Terraform dynamic blocks
- Official [Terraform documentation on dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)
- Some resource types include repeatable nested blocks in their arguments, which typically represent separate objects that are related to (or embedded within) the containing object
- Instead of explicitly and statically defining each of those blocks, we want to create a form of a loop to create them automatically. Dynamic blocks allow us to do that with the help of `for_each`

## 2. The problem - repeatable nested blocks without Dynamic Blocks

- Consider an S3 bucket lifecycle configuration where we need multiple rules for different prefixes.
- Without dynamic blocks, we would have to explicitly define each rule block:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "logs"
    status = "Enabled"
    filter {
      prefix = "logs/"
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 90
    }
  }

  rule {
    id     = "archives"
    status = "Enabled"
    filter {
      prefix = "archives/"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }

  rule {
    id     = "temp"
    status = "Enabled"
    filter {
      prefix = "tmp/"
    }
    transition {
      days          = 7
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 30
    }
  }
}
```

- This is repetitive and hard to maintain. Adding a new rule means copying and modifying an entire block.

## 3. The solution - Dynamic Blocks

- We define the rules as a variable (a map of objects) in `terraform.tfvars`:

```hcl
lifecycle_rules = {
  logs = {
    prefix           = "logs/"
    enabled          = true
    transition_days  = 30
    transition_class = "STANDARD_IA"
    expiration_days  = 90
  }
  archives = {
    prefix           = "archives/"
    enabled          = true
    transition_days  = 60
    transition_class = "GLACIER"
    expiration_days  = 365
  }
  temp = {
    prefix           = "tmp/"
    enabled          = true
    transition_days  = 7
    transition_class = "STANDARD_IA"
    expiration_days  = 30
  }
}
```

- And use a dynamic block in `s3.tf` to generate the rules:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.key
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = rule.value.prefix
      }

      transition {
        days          = rule.value.transition_days
        storage_class = rule.value.transition_class
      }

      expiration {
        days = rule.value.expiration_days
      }
    }
  }
}
```

### 3.1 How the dynamic block works

- `dynamic "rule"` tells Terraform we want to dynamically generate `rule` blocks
- `for_each = var.lifecycle_rules` iterates over the map
- Inside `content { }`, we use `rule.key` (the map key, e.g. "logs") and `rule.value` (the object with prefix, transition_days, etc.)
- The iterator variable name matches the label after `dynamic` — in this case `rule`

## 4. Deploy and verify

- Perform `terraform init`, `plan`, `apply`
- Verify the lifecycle rules with the AWS CLI using terraform output:
```bash
aws s3api get-bucket-lifecycle-configuration \
  --bucket $(terraform output -raw bucket_name) \
  --profile sso-student
```

## 5. Exercises

- Add a fourth lifecycle rule for a `backups/` prefix that transitions to `DEEP_ARCHIVE` after 180 days and expires after 730 days
- Try setting `enabled = false` on one of the rules and observe the plan output
- Use `{ for }` to create an output that shows only the rules where `expiration_days > 60`

## 6. Clean Up

- `terraform destroy`
