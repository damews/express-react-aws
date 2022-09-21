# Terraform Infrastructure for Backend + Frontend with S3 for state files

This project contains Terraform files to create the following architetures for a backend and frontend app:

### Backend
TODO

### Frontend

- S3 for static website hosting
- Cloundfront for Content Delivery (CND)

## Terraform State files

To store the terraform state files, an S3 service need to be provisioned. To create this service, navigate to the `tfstate/` folder. Check the variables beign used in the `terraform.tfvars` file.

Then, simply run:

```sh
$ terraform init
$ terraform apply -var-file="terraform.tfvars"
```

After creating the resources to store the `statefiles`, you will may want to use the external storage for them. Create a `backend.hcl` file to store the informations about the backend external storage. The file will contains the format:

```terraform
bucket = [s3 bucket resource name]
encrypt = true
region = [region to the used by the terraform]
profile = [aws cli profile to use]
key = "terraform.tfstate"
workspace_key_prefix = [folder hierarchy for the resource beign created, e.g: "frontend" or "backend/ecr"]
dynamodb_table = [dynamo db resource name]
```

Then, for each folder (resource to be created), run:

```sh
terraform init -backend-config=backend.hcl
```

## Backend
TODO

## Frontend

You may want to create the infrastructure for multiple environments. To do this you will need to store the `.statefile` for each one. This can be done using `terraform workspaces` and using the proper `.tfvars` variable file. Check the `environment/` for each environment var file.

To create or select a workspace, run:
```sh
#To create and enter
terraform workspace new [environment name]

#To select a existing one
terraform workspace select [environment name]
```

For example, to create the services for the `dev` environment, run:

```sh
$ terraform init -backend-path="backend.hcl"
$ terraform workspace new dev
$ terraform plan -var-file="environments/dev.tfvars" -out dev.tfplan
$ terraform apply dev.tfplan -var-file="environments/dev.tfvars"  
```
