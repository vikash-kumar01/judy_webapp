pipeline{

    agent any 

    parameters{

        choice(name: 'action', choices: 'apply\ndelete', description: 'Apply or Delete the app')
        string(name: 'region', defaultValue: 'us-east-1', description: 'Choose AWS Region')
        string(name: 'cluster', defaultValue: 'demo-cluster', description: 'Choose AWS Clustername')
    }

    environment{

        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_KEY_ID')
    }

    stages{

        stage('Git Checkout'){

            steps{

                script {
                    
                    git branch: 'devops', url: 'https://github.com/vikash-kumar01/judy_webapp.git'

                }
            }
        }
        stage('docker image build'){
            steps{
                script{

                    sh """
                    aws configure set aws_access_key_id "$ACCESS_KEY"
                    aws configure set aws_secret_access_key "$SECRET_KEY"
                    aws configure set region "${params.region}"
                    aws ecr get-login-password --region ${params.region} | docker login --username AWS --password-stdin 996864587356.dkr.ecr.${params.region}.amazonaws.com
                    docker build -t webapp .
                    docker tag webapp:latest 996864587356.dkr.ecr.${params.region}.amazonaws.com/webapp:latest
                    docker push 996864587356.dkr.ecr.${params.region}.amazonaws.com/webapp:latest
                    """
                }
            }
        }
        stage('EKS Module'){
            steps{

                script{
                        dir('eks_module') {
                        sh """
                         terraform init
                         terraform plan -var "access_key=$ACCESS_KEY" -var "secret_key=$SECRET_KEY" --var-file="./config/terraform.tfvars"
                         terraform apply -var "access_key=$ACCESS_KEY" -var "secret_key=$SECRET_KEY" --var-file="./config/terraform.tfvars" --auto-approve
                        """
                    }
                }
            }
        }
        stage('Connect with eks cluster'){

            steps{

                script{

                    sh """
                    aws configure set aws_access_key_id "$ACCESS_KEY"
                    aws configure set aws_secret_access_key "$SECRET_KEY"
                    aws configure set region "${params.region}"

                    aws eks --region "${params.region}" update-kubeconfig --name ${params.cluster}

                    """
                }
            }
        }
        stage('Deployment on EKS Cluster'){

            when{ expression { params.action == 'apply' } }

            steps{
                script{

                    sh """
                    kubectl apply -f .

                    kubectl get all 

                    """
                }
            }
        }
        stage('Delete App on EKS Cluster'){

            when{ expression { params.action == 'delete' } }

            steps{
                script{

                    sh """
                    kubectl delete -f .

                    kubectl get all 

                    """
                }
            }
        }
    }
}