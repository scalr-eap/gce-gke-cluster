# AWS EKS cluster

Creates and GKE Cluster in the given Region.

User can choose:

1. Name of the cluster
1. Region

Template uses the new (re:Invent 2019) `aws_eks_node_group` resource to automate node deployment and cluster join.

Template can be run as follows:

* Locally
* Scalr Next-gen as the remote backend
* Scalr Next-Gen Service Catalog Offering

## Using Locally

1. Pull the repo
1. Set variable values in `terraform.tvars.(json)`
1. Add your AWS access and secret keys to `terraform.tfvars(.json)`, or enter them at the run time prompts. (scalr_aws_access_key, scalr_aws_secret_key)
1. Run `terraform init;terraform apply` and watch the magic happen.

## Using with Scalr Next-Gen as Remote Backend

1. Pull the repo
1. Create a CLI workspace in Scalr Next-Gen and configure the backend to match in main.tf.
1. Create an TF API token in Scalr Next-Gen and add it to ~/.terraformrc.
1. In Scalr Workspace add Terraform variables and values as follows (note that terraform.tfvars(.json) in the template is not used with a remote backend).
   1. region
   1. cluster_name
1. Run `terraform init;terraform apply` and watch the magic happen.

## Using with Scalr Next-Gen Service Catalog Offering.

In general follow the example here https://scalr-athena.readthedocs-hosted.com/en/latest/next-gen/service_catalog.html#service-catalog

1. Create Policies (scalr-module.hcl shows the policy bindings that are required)
   1. cloud.locations - Policy to limit the cloud locations (note this can be all locations but the policy must exist)
   1. cloud.instance_types - Restrict the instance types that are allowed. Minimum 4GB of ram.
1. Create a Global Variable `name_fmt` with REGEX `^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$`
1. Create a Global Variable `numeric_fmt` with REGEX `^[0-9][0-9]*$`
1. Fork or clone the Source repo (https://github.com/scalr-eap/aws_eks_cluster)
1. Create the Service Catalog offering pointing to your copy repo
1. Request the offering. It can take 10-15 minutes to deploy the cluster.
