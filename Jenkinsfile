pipeline{

    agent any

    parameters{

        string(name: 'cluster', defaultValue: 'demo-cluster', description: 'Choose EKS ClusterName')
        string(name: 'region', defaultValue: 'us-east-1', description: 'Choose EKS Cluster Region')
    }

    environment{

        ACCESS_KEY= credentials('AWS_ACESS_KEY_ID')
        SECRET_KEY= credentials('AWS_SECRET_KEY_ID')
    }

    stages{

        stage('Git Checkout'){

            steps{

                script{

                    git branch: 'devops', url: 'https://github.com/mohammed-mubashshir-alam/java_webapp.git'
                }
            }
        }
            stage('UNIT testing'){

             steps{

                script{

                    sh 'mvn test'
                }               
            }
        }
        stage('Integration testing'){

             steps{

                script{

                    sh 'mvn verify -DskipTests'
                }               
            }
        }
        stage('Static Code Analysis'){

             steps{

                script{

                    withSonarQubeEnv(credentialsId: 'squbeapi') {
                         
                         sh 'mvn clean package sonar:sonar'
                     }
                }               
            }
        }
        stage('QualityGate status Check'){

             steps{

                script{

                  waitForQualityGate abortPipeline: false, credentialsId: 'squbeapi'
                }               
            }
        }
        stage('Maven Build'){

             steps{

                script{

                  sh 'mvn clean install'
                }               
            }
        }
        stage('Nexus artifact upload'){

            steps{

                script{

                    def readPomVersion = readMavenPom file : 'pom.xml'

                    def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "devops-snapshot" : "devops-release"

                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: 'springboot',
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                            ]
                        ], 
                        credentialsId: 'nexus-creds',
                         groupId: 'com.example', 
                         nexusUrl: '3.89.58.183:8081', 
                         nexusVersion: 'nexus3', 
                         protocol: 'http', 
                         repository: nexusRepo, 
                         version: "${readPomVersion.version}"
                }
            }
        }
        stage('Docker Image Build'){

             steps{

                script{

                  sh 'docker image build -t mohammedmubashshiralam/webapp:latest .'
                }               
            }
        }
        stage('Docker Image Push'){

             steps{

                script{
              withCredentials([string(credentialsId: 'dockerhub_pass', variable: 'dockerhub')]) {
                  sh """
                  docker login -u mohammedmubashshiralam -p ${dockerhub}
                  docker image push mohammedmubashshiralam/webapp:latest
                  docker rmi mohammedmubashshiralam/webapp:latest
                  """
                  }
                }               
            }
        }
        stage('EKS Cluster Creation'){

             steps{

                script{

                 dir('eks_module') { 
                    

                    sh """
                    terraform init
                    terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' --var-file=./config/terraform.tfvars
                    terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' --var-file=./config/terraform.tfvars --auto-approve
                    """
                 }           
            }
        }
        }
        stage('Connect to EKS'){

             steps{

                script{
                  sh """
                  aws configure set aws_access_key_id "$ACCESS_KEY"
                  aws configure set aws_secret_access_key "$SECRET_KEY"
                   aws configure set region "${params.region}"
                  aws eks --region ${params.region} update-kubeconfig  --name  ${params.cluster}
                  """
                }               
            }
        }
        stage('Deploy Application to EKS'){

             steps{

                script{
                  sh """
                      kubectl apply -f .
                  """
                }               
            }
        }
    }
}