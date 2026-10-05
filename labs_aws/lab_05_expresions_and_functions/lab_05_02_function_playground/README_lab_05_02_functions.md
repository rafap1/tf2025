# Lab 05-02 - Function Playground

NOTE: You can view this markdown file rendered in Visual code with the following key combinations:

	- Windows **Ctrl + Shift + V**
	- Linux : **Ctrl + Shift + V**
	- macOS:  **command  + shift +V**

## Terraform Functions documentation
- https://developer.hashicorp.com/terraform/language/functions

## About this lab
- In this lab we do not create any resources - we just play with Terraform functions
- This lab has no `provider.tf` file we do not have a `provider` block 
- We could have added a `terraform` block if we wanted to specify the terraform version (for example some functions may have been introduced in version 1.X)
- In this lab we do not need to use terraform init or terraform plan.  
- We can run terraform apply to generate the outputs. You will notice that terraform creates an empty state file. 


## Purpose of the lab 
- Help you prepare a simple environment when you have to explore function behavior on your own
- Practice a subset of Terraform built-in functions that make your code more robust and maintainable:
   - **CIDR functions**: Network calculations and subnet management
   - **zipmap**: Combine lists into maps
   - **try**: Handle errors gracefully
   - **can**: Validate expressions
   - **coalesce**: Provide fallback values

- Practice the `flatten` function

## How to Use this lab
0. **terraform apply** to initialize outputs (note we do not need `terraform init` - no provider or modules to initialize)


1. **Use terraform console** to test functions 
(note type `exit` or `Ctrl-D` to exit the console)

   ```bash
   terraform console
   ```

2. **Try these commands in the console**:
   ```hcl
   # CIDR functions
   cidrhost("10.0.0.0/16", 1)
   cidrsubnets("10.0.0.0/16", 8, 8, 8, 4)
   
   # zipmap
   zipmap(["web", "api", "db"], ["10.0.1.10", "10.0.1.20", "10.0.1.30"])
   
   # Error handling
   try(cidrnetmask("192.168.1.0/24"), "invalid")
   try(cidrnetmask("10.0.0.0"), "invalid")
   can(cidrnetmask("192.168.1.0/24"))
   can(cidrnetmask("192.168.1.0/33")) ## Note wrong subnet mask

   # Or use the local values - Before doing soe explore file locals.tf
   local.vpc_gateway
   local.safe_cidr_valid
   local.robust_env_config
   ```

4. **View all results**:
   ```bash
   terraform apply
   ```

## Function Categories

### CIDR Functions
- **`cidrhost(cidr, host_num)`** - Get specific IP from CIDR block
- **`cidrnetmask(cidr)`** - Extract netmask from CIDR
- **`cidrsubnet(cidr, newbits, netnum)`** - Create subnet from larger CIDR
- **`cidrsubnets(cidr, newbits...)`** - Create multiple subnets at once

### Data Manipulation
- **`zipmap(keys, values)`** - Combine two lists into a map

### Error Handling & Validation
- **`try(expr1, expr2, ...)`** - Try expressions in order, return first successful
- **`can(expression)`** - Test if expression is valid (returns true/false)
- **`coalesce(val1, val2, ...)`** - Return first non-null value

## Practice Exercises

### Beginner
1. Create a subnet for each availability zone using `cidrsubnet`
2. Map server names to their ports using `zipmap`
3. Use `try` to handle missing configuration values

### Intermediate
4. Validate CIDR blocks before using them with `can`
5. Create fallback machine types with `coalesce`
6. Build robust network configurations combining multiple functions

### Advanced
7. Create a subnet calculator that handles invalid inputs
8. Build a configuration validator using `can` and `try`
9. Design a multi-environment setup with smart defaults

## Real-World Use Cases

### Network Planning
```hcl
# Automatically create subnets for multiple AZs
subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8)  # /24 subnets
```

### Configuration Safety
```hcl
# Handle missing or invalid values gracefully
machine_type = coalesce(try(var.does_not_exist, null), "e2-micro")
```

### Input Validation
```hcl
# Validate user inputs before using them
valid_cidr = can(cidrnetmask(var.vpc_cidr)) ? var.vpc_cidr : "10.0.0.0/16"
```

## Key Benefits

- **Reliability**: Handle edge cases and invalid inputs
- **Maintainability**: Cleaner code with built-in error handling
- **Flexibility**: Provide sensible defaults and fallbacks
- **Network Management**: Automate subnet calculations and IP assignments

## Common Patterns

1. **Safe Access**: `try(object.property, default_value)`
2. **Validation**: `can(expression) ? expression : fallback`
3. **Defaults**: `coalesce(user_value, env_default, global_default)`
4. **Network Math**: `cidrsubnet(base_cidr, additional_bits, subnet_number)`