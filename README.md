# Workflow for deploying infrastructure as code using terraform in AWS

## Summary

Be able to deploy any infrastructure using terraform into AWS tenant.

![Terraform workflow with approvals](https://user-images.githubusercontent.com/87304455/182608836-79c531f8-7e54-41b2-a838-9d8f6aae15b5.jpg)


## Usage pipeline
Call directly from your workflow file like:

	jobs:    
	  JAVA:
		uses: Iberia-Ent/software-engineering--workflow-terraform/.github/workflows/ci-cd-terraform.yml@v1.2
		with:
			ENVIRONMENT_NAME: {{ github.event.inputs.ENVIRONMENT_NAME }}
			WORKING_FOLDER: ${{ github.event.inputs.WORKING_FOLDER }} 
		secrets:
			AWS_DEPLOYMENT_ROLE: ${{ secrets.AWS_DEPLOYMENT_ROLE }}		 

				
### Note: Keep the working folder value (./) if your terraform code is located in root folder.

| Environment Name | Working folder | 
| -------- | -------- | 
| Production  | prod  | 

	  ENVIRONMENT_NAME: 
		description: 'Environment name'
		required: true
		default: 'Production'
		
	  WORKING_FOLDER:
		description: 'Level where you run your code'
		default: './'
		required: false

## Set up repository properties

### Environment's configuration

1. Create an environment called "Production" add AWS_DEPLOYMENT_ROLE secret and add the review team in charge to approve the deployment.

#### NOTE: The team has to be added in to Settings--> Manage Access before to add into enviroments section.
#### NOTE_2: The AWS_DEPLOYMENT_ROLE value is the role to assume of the aws account that you want to deploy. So you need to create a role to assume in your aws account where you want to deploy your infrastructure and then you have to add it in deployments-sdlc-common in PolicyGithubOperationRunners. 

### Branches rules

1. We are using main branch for deploying so we need to protect that branch.
   Branches:
   * main
   
2. Add some rules to main branch to make sure that you follow the flow and anyone can push code in main branch, just pull request.
	* main: 
		- Require a pull request before merging and check "Require approvals" option.
		- Require status checks to pass before merging and chech "Require branches to be up to date before merging" option.		  
		- Include administrators
		- Restrict who can push to matching branches: Add to the devops-operations team and iberia infrastructure team.

## Set up terraform pipeline

### Pipeline files hierarchy 

You should have this files:

* main.tf
* .github/config/ci-config.json
* .github/workflows/ci-cd-terraform.yml

You should modify this files:

* .github/config/ci-config.json


### Set up ci-config.json file
#### Variables
	
	
| Variable | Required | Type |
| -------- | -------- | ---- | 
| AWS_REGION  | yes  | string  | 
| TERRAFORM_VERSION  | yes  | string  | 
| NODEJS_VERSION  | yes  | string  | 
| VAR_FILE_NAME  | yes  | string  |
			
	
For setting up the ci-config.json file with your custom properties of your project, go to your working feature branch and make the changes that you need using the above variables for example: 

	{
		"prod": {
			"AWS_REGION": "eu-west-1",		
			"TERRAFORM_VERSION": ">= 1.0",
			"NODEJS_VERSION": "14",
			"VAR_FILE_NAME": "terraform.tfvars"
		}
	}



### Deploy your infrastructure

- Create a feature working branch. For example: feat-menu
- Add your changes or commit it into your working branch.
- Push your commits to remote repository. 
- For checking your terraform plan please go to Actions tab, select the workflow and click "Run workflow" button. Choose your working branch and select the enviroment name in case that you have multiples options. As an optional, you can type the working folder for account repositories and remember that for executing the code located in main level you have to type ./. Click to "Run workflow" button.
- For deploying your code, open a "Pull Request", select base branch: main and compare branch: feature-1 (working feature branch created for yourself). You have to wait that your responsable review your pull request and approve it so when it happens you can confirm the pull request.
- Go to Actions tab, select the workflow, click in "Run workflow" button, choose main branch, select the enviroment name and click to "Run workflow" button.
- Then the release managenment team has to approve the deployment.
- Once they approve the deployment, check if it has finished sucessfully the pipeline.
#### NOTE: For deploying into Production environment the team in charge to have a control of that (release-management) has to approve your deploy, so the pipeline will be stopped until that approval.  

- Delete your custom branch. Example: feature-1


### Use external repositories modules in terraform

We are supporting ssh callers so you have to make sure that your source is like:

	   source = "git@github.com:[Organization]/[Repository name].git?ref=[release version]"
	   source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module.git?ref=v3.11.0"

### Assume role
If you are using a new AWS account, you have to create in that account an assume role in order to have access to all AWS services that you want to deploy in this repository.

1. Create the new assume role in the new account following the naming convention.

Naming Convention: arn:aws:iam::[AccountID]:role/RoleGithubRunners_Infrastructure_[Environment]_[AWS-Business-Domain]
Environment: Int, Pre, Prod.
AWS-Business-Domain: backoffice, operations, commercial, cargo or your new account name.

Example: arn:aws:iam::111122223333:role/RoleGithubRunners_Infrastructure_Pre_cargo

- Add the Trust relationships in the new role:

		{
			"Effect": "Allow",
            "Principal": {
                "AWS": "[ORIGIN ACCOUNT WILL ASSUME THE ROLE]"
            },
            "Action": "sts:AssumeRole"
        }
		
		where [ORIGIN ACCOUNT WILL ASSUME THE ROLE] = arn:aws:iam::111122223333:role/RoleGithubRunners please change the account id.

- Add the permissions of the services that you want to access in this account. Example: AmazonS3FullAccess

2. In the origin account which we will assume the role we have to create a custom policy or if exist add the new arn role that we have created in the step 1 and then we have to add that policy into the role arn:aws:iam::111122223333:role/RoleGithubRunners.

		{
			"Statement": [
				{
					"Action": [
						"sts:AssumeRole",
						"sts:TagSession"
					],
					"Effect": "Allow",
					"Resource": [
						"arn:aws:iam::111122223333:role/RoleGithubRunners",
						"arn:aws:iam::111122223333:role/RoleGitHubRunners_Infrastructure_Pre",
						"arn:aws:iam::111122223333:role/RoleGithubRunners_Infrastructure_Pre_cargo",
						"arn:aws:iam::111122223333:role/RoleGithubRunners_Infrastructure_Networking"
					]
				}
			],
			"Version": "2012-10-17"
		}

Details where we have the runner, role and policy:

	AWS Runner Account: deployments-sdlc-common
	Role Name: RoleGithubRunners
	Policy: PolicyGithubRunners
	

## Contributing

Briefly explains how your team members or others can contribute to the project

For the contribution and workflow guide, see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Maintainers

Contact information of the team member whose is responsible for the project, see [CONTRIBUTING.md](./CONTRIBUTING.md).
