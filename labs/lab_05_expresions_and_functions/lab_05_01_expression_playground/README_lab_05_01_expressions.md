# Lab 05-01 - Expression Playground

## About this lab
- In this lab we do not create any resources - we just play with Terraform functions
- This lab has no `provider.tf` file we do not have a `provider` block 
- We could have added a `terraform` block if we wanted to specify the terraform version (for example some functions may have been introduced in version 1.X)
- In this lab we do not need to use terraform init or terraform plan.  
- We can run terraform apply to generate the outputs. You will notice that terraform creates an empty state file. 

## Purpose of this lab  
- Practice Terraform expressions without needing cloud resources or providers. This lab helps you understand:
   - `for` expressions with lists and maps
   - Filtering with `if` conditions
   - Transforming data structures
   - Working with objects

- More importantly it shows you how to set up a small testing environment when you need to verify or understand the behavior of an expression or object.

## How to Use this lab
1. **terraform apply** to initialize outputs (note we do not need `terraform init` - no provider or modules to initialize)

2. **Use terraform console** to test expressions:
   ```bash
   terraform console
   ```
   - Type `exit` or `Ctrl-D` to exit terraform console

  - NOTE : 
   - Normally we discourage running `terraform console` by itself since it locks the state file. 
   - We advise using `echo` to pipe commands to `terraform console`
   - In this lab using `terraform console` is not risky and it helps practice concepts.
3. **Try these commands in the console**:
   ```hcl
   # Test simple expressions
   local.fruits
   local.fruits[1]
   local.fruits_upper
   local.big_numbers
   
   # Test map expressions
   local.colors
   local.colors["red"]
   local.colors_info
   local.server_specs
   local.server_specs["cpu"]
   
   # Test filtering
   local.high_cpu_servers
   local.engineers
   ```

4. **View all results at once**:
   ```bash
   terraform output
   ```

## Practice Exercises

Try modifying the expressions in `locals.tf.tf`:

### Beginner
1. Create a list of fruits with their lengths: `["apple: 5", "banana: 6", ...]`
2. Filter numbers to only show even numbers
3. Create a map of server names to their memory sizes

### Intermediate  
4. Find servers with more than 30GB disk space
5. Calculate total salary for engineering department
6. Create a list of employee info: `["Alice (engineering)", "Bob (marketing)", ...]`

### Advanced
7. Group employees by department (hint: use multiple expressions)
8. Find the server with the highest CPU count
9. Create a map of departments to average salaries

## Sample Solutions

Add your solutions to `locals.tf` and test them with `terraform console`!

## Key Concepts Practiced

- **List comprehension**: `[for item in list : expression]`
- **Map comprehension**: `{for k, v in map : k => expression}`  
- **Filtering**: `[for item in list : item if condition]`
- **Object access**: `object.property`
- **Data transformation**: Converting between lists, maps, and objects