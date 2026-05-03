# Expression Playground - Practice Terraform Expressions
# No provider needed - use `terraform console` to test these expressions

locals {
  # Sample data structures for practicing expressions

  # Simple lists
  fruits  = ["apple", "banana", "cherry", "date"]
  numbers = [1, 2, 3, 4, 5]

  # Simple map
  colors = {
    red   = "#FF0000"
    green = "#00FF00"
    blue  = "#0000FF"
  }

  # Map of objects  
  servers = {
    web = {
      cpu    = 2
      memory = 4
      disk   = 20
      env    = "prod"
    }
    api = {
      cpu    = 4
      memory = 8
      disk   = 40
      env    = "prod"
    }
    db = {
      cpu    = 8
      memory = 16
      disk   = 100
      env    = "prod"
    }
  }

  # List of objects with nested objects
  employees = [
    {
      name       = "Alice"
      department = "engineering"
      salary     = 75000
      address = {
        street = "123 Main St"
        city   = "San Francisco"
        state  = "CA"
        zip    = "94105"
      }
    },
    {
      name       = "Bob"
      department = "marketing"
      salary     = 65000
      address = {
        street = "456 Oak Ave"
        city   = "New York"
        state  = "NY"
        zip    = "10001"
      }
    },
    {
      name       = "Carol"
      department = "engineering"
      salary     = 80000
      address = {
        street = "789 Pine Rd"
        city   = "Austin"
        state  = "TX"
        zip    = "73301"
      }
    }
  ]

  # ===== PRACTICE EXPRESSIONS =====

  # 1. Simple list transformations
  fruits_upper = [for fruit in local.fruits : upper(fruit)]

  # 2. List with filtering
  big_numbers = [for num in local.numbers : num if num > 3]

  # 3. Map to list (extract values)
  hex_colors = [for color in local.colors : color]

  # 4. Map to map transformation
  colors_info = { for k, v in local.colors : k => "Color ${k} is ${v}" }

  # 5. Extract specific fields from map of objects
  server_names = [for name, config in local.servers : name]
  server_cpus  = [for server in local.servers : server.cpu]

  # 6. Create map from map of objects
  server_specs = { for k, v in local.servers : k => "${v.cpu}CPU/${v.memory}GB" }

  # 7. Filter map of objects
  high_cpu_servers = { for k, v in local.servers : k => v if v.cpu >= 4 }

  # 8. Work with list of objects
  employee_names = [for emp in local.employees : emp.name]

  # 9. Filter list of objects
  engineers = [for emp in local.employees : emp if emp.department == "engineering"]

  # 10. Transform list of objects to map
  salary_map = { for emp in local.employees : emp.name => emp.salary }

  # 11. Access nested objects - extract cities
  employee_cities = [for emp in local.employees : emp.address.city]

  # 12. Create full addresses
  full_addresses = [for emp in local.employees : "${emp.address.street}, ${emp.address.city}, ${emp.address.state} ${emp.address.zip}"]

  # 13. Filter by nested object property
  california_employees = [for emp in local.employees : emp if emp.address.state == "CA"]

  # 14. Create map with nested object access
  employee_locations = { for emp in local.employees : emp.name => "${emp.address.city}, ${emp.address.state}" }

  # 15. Filter by nested object property - Texas employees
  texas_employees = [for emp in local.employees : emp if emp.address.state == "TX"]

  # 16. Group employees by department (multiple expressions)
  # First, get unique departments
  departments = toset([for emp in local.employees : emp.department])

  # Then, create a map of department to list of employees
  employees_by_department = {
    for dept in local.departments : dept => [
      for emp in local.employees : emp if emp.department == dept
    ]
  }
}
