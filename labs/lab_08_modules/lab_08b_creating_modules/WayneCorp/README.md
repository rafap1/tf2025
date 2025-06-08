Lab Terraform Modules - Example 1

Example creating simple but complete modules
- vpc
- server instances

The goal of this lab is to understand the relationships between the root module and the called modules
- Where the modules are defined
    - What "input" parameters they expect 
    - What "outputs" they produce
- How they are called
    - How to pass parameters - required vs optional parameters
    - How to retrieve outputs from "inner" modules

We are simulating a company (WayneCorp) with several projects (project1, project2) that use a common set of modules
The simplified structure is:

rp4:WayneCorp$ tree -d
.
├── modules
│   ├── aws-web-server-instance
│   └── aws-web-vpc
├── project1
└── project2

NOTE: The modules we create (server, vpc) are probably too "thin" (thin wrapper around vpc and ec2 instance) but are meant to serve as illustration
- 



