
# AWS ECS

This repository contains the Terraform modules for creating a production ready ECS in AWS.

-   [What is ECS?](https://github.com/sikandarqaisar/Terraform-ECS-cluster#what-is-ecs)
-   [ECS infrastructure in AWS](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ecs-infra)
-   [ECS Terraform module](https://github.com/sikandarqaisar/terraform-ECS-Cluster#terraform-module)
-   [How to create the infrastructure](https://github.com/sikandarqaisar/terraform-ECS-Cluster#create-it)
-   [Things you should know](https://github.com/sikandarqaisar/terraform-ECS-Cluster#must-know)
    -   [SSH access to the instances](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ssh-access-to-the-instances)
    -   [ECS configuration](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ecs-configuration)
    -   [ECS instances](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ecs-instances)
    -   [LoadBalancer](https://github.com/sikandarqaisar/terraform-ECS-Cluster#loadbalancer)
    -   [ECS deployment strategies](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ecs-deployment-strategies)
    -   [System containers & custom boot commands](https://github.com/sikandarqaisar/terraform-ECS-Cluster#system-containers-and-custom-boot-commands)
    -   [EC2 node security and updates](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ec2-node-security-and-updates)
    -   [Service discovery](https://github.com/sikandarqaisar/terraform-ECS-Cluster#service-discovery)
    -   [ECS detect deployments failure](https://github.com/sikandarqaisar/terraform-ECS-Cluster#ecs-detect-deployments-failure)

## [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#what-is-ecs)What is ECS

ECS stands for EC2 Container Service and is the AWS platform for running Docker containers. The full documentation about ECS can be found  [here](https://aws.amazon.com/ecs/), the development guide can be found  [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html). A more fun read can be found at  [The Hitchhiker's Guide to AWS ECS and Docker](http://start.jcolemorrison.com/the-hitchhikers-guide-to-aws-ecs-and-docker/)

To understand ECS it is good to state the obvious differences against the competitors like  [Kubernetes](https://kubernetes.io/)  or  [DC/OS Mesos](https://docs.mesosphere.com/). The mayor differences are that ECS can not be run on-prem and that it lacks advanced features. These two differences can either been seen as weakness or as strengths.

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#aws-specific)AWS specific

You can not run ECS on-prem because it is an AWS service and not installable software. This makes it easier to setup and maintain than hosting your own Kubernetes or Mesos on-prem or in the cloud. Although it is a service it's not the same as  [Google hosted Kubernetes](https://cloud.google.com/container-engine/). Why? Google really offers Kubernetes as a SAAS. Meaning, you don't manage any infrastructure while ECS actually requires slaves and therefore infrastructure.

The difference between running your own Kubernetes or Mesos and ECS is the lack of maintenance of the master nodes on ECS. You are only responsible for allowing the EC2 nodes to connect to ECS and ECS does the rest. This makes the ECS slave nodes replaceable and allows for low maintenance by using the standard AWS ECS optimized OS and other building blocks like autoscale etc..

## [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-infra)ECS infra

As stated above ECS needs EC2 nodes that are being used as slaves to run Docker containers on. To do so you need infrastructure for this. Here is an ECS production-ready infrastructure diagram.


![ECS infra](https://github.com/sikandarqaisar/Terraform-ECS-Cluster/blob/master/ecs-infra.png))


What are we creating:

-   VPC with a /16 ip address range and an internet gateway
-   We are choosing a number of availability zones we want to use. For high-availability we need at least two
-   In every availability zone we are creating a subnet with a /24 ip address range
    -   Public subnet convention is 10.x.0.x and 10.x.1.x etc..
-   In the public subnet we place a NAT gateway and the LoadBalancer
-   The public subnets are also used in the autoscale group which places instances in them
-   We create an ECS cluster where the instances connect to


## Terraform module

To be able to create the stated infrastructure we are using Terraform. To allow everyone to use the infrastructure code, this repository contains the code as Terraform modules so it can be easily used by others.

Creating one big module does not really give a benefit of modules. Therefore the ECS module itself consists of different modules. This way it is easier for others to make changes, swap modules or use pieces from this repository even if not setting up ECS.

Details regarding how a module works or why it is setup is described in the module itself if needed.

Modules need to be used to create infrastructure. For an example on how to use the modules to create a working ECS cluster see  **main.tf** in **ECS Module** 

**Note:**  You need to use Terraform version 0.9.5 and above

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#List-of-modules)List of modules
-   **ECS**
- -   **Template**
-   **VPC**
-   **IAM**
-   **LoadBalancer-AutoScaling**
- -   **Template**

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#conventions)Conventions

These are the conventions we have in every module

-   Contains **main.tf** where all the terraform code is
-   Contains **outputs.tf** with the output parameters
-   Contains **variables.tf** which sets required attributes
-   For grouping in AWS we set the tag "Environment" everywhere where possible

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#module-structure)Module structure

[![Terraform module structure](https://github.com/sikandarqaisar/Terraform-ECS-Cluster/blob/master/ecs-terraform-modules.png)](https://github.com/sikandarqaisar/Terraform-ECS-Cluster/blob/master/ecs-terraform-modules.png)


## Create it

To create a working ECS cluster from this repository see  **prod_var.tfvars**  in main ECS module .

Quick way to create this from the repository as is:

``terraform apply  -var-file=prod_var.tfvarsz``

Actual way for creating everything using the default terraform flow

``terraform init
terraform plan  -var-file=prod_var.tfvars
terraform apply -var-file=prod_var.tfvars``



## Must know

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ssh-access-to-the-instances)SSH access to the instances

You should not put your ECS instances directly on the internet. You should not allow SSH access to the instances directly but use a bastion server for that. Having SSH access to the acceptance environment is fine but you should not allow SSH access to production instances. You don't want to make any manual changes in the production environment.


### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-configuration)ECS configuration

ECS is configured using the  _/etc/ecs/ecs.config_  file as you can see  [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html). There are two important configurations in this file. One is the ECS cluster name so that it can connect to the cluster, this should be specified from terraform because you want this to be variable. The other one is access to Docker Hub to be able to access private repositories. To do this safely use an S3 bucket that contains the Docker Hub configuration. See the  _ecs_config_  variable in the  _ecs_instances_module for an example.


### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-instances)ECS instances

Normally there is only one group of instances like configured in this repository. But it is possible to use the  _ecs_instances_module to add more groups of different type of instances that can be used for different deployments. This makes it possible to have multiple different types of instances with different scaling options.

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#loadbalancer)LoadBalancer

It is possible to use the Application LoadBalancer and the Classic LoadBalancer with this setup. The default configuration is Application LoadBalancer because that makes more sense in combination with ECS.


### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-deployment-strategies)ECS deployment strategies

ECS has a lot of different ways to deploy or place a task in the cluster. You can have different placement strategies like random and binpack, see here for full  [documentation](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html). Besides the placement strategies, it is also possible to specify constraints, as described  [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-constraints.html). The constraints allow for a more fine-grained placement of tasks on specific EC2 nodes, like  _instance type_  or custom attributes.


### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#system-containers-and-custom-boot-commands)System containers and custom boot commands

In some cases, it is necessary to have a system 'service' running that does a particular task, like gathering metrics. It is possible to add an OS specific service when booting an EC2 node but that means you are not portable. A better option is to have the 'service' run in a container and run the container as a 'service', also called a System container.

ECS has different  deployment strategies but it does not have an option to run a system container on every EC2 node on boot. It is possible to do this via ECS workaround or via Docker.

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-workaround)ECS workaround

The ECS workaround is described here  [Running an Amazon ECS Task on Every Instance](https://aws.amazon.com/blogs/compute/running-an-amazon-ecs-task-on-every-instance/). It basically means use a Task definition and a custom boot script to start and register the task in ECS. This is awesome because it allows you to see the system container running in ECS console. The bad thing about it is that it does not restart the container when it crashes. It is possible to create a Lambda to listen to changes/exits of the system container and act on it. For example, start it again on the same EC2 node.

### [](https://github.com/arminc/terraform-ecs#ec2-node-security-and-updates)EC2 node security and updates

Because the EC2 nodes are created by us it means we need to make sure they are up to date and secure. It is possible to create an own AMI with your own OS, Docker, ECS agent and everything else. But it is much easier to use the  [ECS optimized AMIs](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)  which are maintained by AWS with a secure AWS Linux, regular security patches, recommended versions of ECS agent, Docker and more...

To know when to update your EC2 node you can subscribe to AWS ECS AMI updates, like described.  Note: We can not create a sample module for this because terraform does not support email protocol on SNS.

If you need to perform an update you will need to update the information in the  _ecs_instances_  and then apply the changes on the cluster. This will only create a new  _launch_configuration_  but it will not touch the running instances. Therefore you need to replace your instances one by one. There are three ways to do this:

Terminating the instances, but this may cause disruption to your application users. By terminating an instance a new one will be started with the new  _launch_configuration_

Double the size of your cluster and your applications and when everything is up and running scale the cluster down. This might be a costly operation and you also need to specify or protect the new instances so that the AWS auto scale does not terminate the new instances instead of the old ones.

The best option is to drain the containers from an ECS instance like described. Then you can terminate the instance without disrupting your application users. This can be done by doubling the EC2 nodes instances in your cluster or just by one and doing this slowly one by one. Currently, there is no automated/scripted way to do this.

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#service-discovery)Service discovery

ECS allows the use of  ALB and ELB facing  Internally or Externally which allows for a simple but very effective service discovery. If you encounter the need to use external tools like consul etc... then you should ask yourself the question: Am I not making it to complex?

Kubernetes and Mesos act like a big cluster where they encourage you to deploy all kinds of things on it. ECS can do the same but it makes sense to group your applications to domains or logical groups and create separate ECS clusters for them. This can be easily done because you are not paying for the master nodes. You can still be in the same AWS account and the same VPC but on a separate cluster with separate instances.

### [](https://github.com/sikandarqaisar/Terraform-ECS-Cluster#ecs-detect-deployments-failure)ECS detect deployments failure

When deploying manually we can see if the new container has started or is stuck in a start/stop loop. But when deploying automatically this is not visible. To make sure we get alerted when containers start failing we need to watch for events from ECS who state that a container has STOPPED.
