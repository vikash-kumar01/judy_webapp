pipeline{

    agent any

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
        //     stage('UNIT testing'){

        //      steps{

        //         script{

        //             sh 'mvn test'
        //         }               
        //     }
        // }
        // stage('Integration testing'){

        //      steps{

        //         script{

        //             sh 'mvn verify -DskipTests'
        //         }               
        //     }
        // }
        // stage('Static Code Analysis'){

        //      steps{

        //         script{

        //             withSonarQubeEnv(credentialsId: 'squbeapi') {
                         
        //                  sh 'mvn clean package sonar:sonar'
        //              }
        //         }               
        //     }
        // }
        // stage('QualityGate status Check'){

        //      steps{

        //         script{

        //           waitForQualityGate abortPipeline: false, credentialsId: 'squbeapi'
        //         }               
        //     }
        // }
        stage('Maven Build'){

             steps{

                script{

                  sh 'mvn clean install'
                }               
            }
        }
        // stage('Nexus artifact upload'){

        //     steps{

        //         script{

        //             def readPomVersion = readMavenPom file : 'pom.xml'

        //             def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "devops-snapshot" : "devops-release"

        //             nexusArtifactUploader artifacts: [
        //                 [
        //                     artifactId: 'springboot',
        //                     classifier: '', 
        //                     file: 'target/Uber.jar', 
        //                     type: 'jar'
        //                     ]
        //                 ], 
        //                 credentialsId: 'nexus-creds',
        //                  groupId: 'com.example', 
        //                  nexusUrl: '18.212.216.107:8081', 
        //                  nexusVersion: 'nexus3', 
        //                  protocol: 'http', 
        //                  repository: nexusRepo, 
        //                  version: "${readPomVersion.version}"
        //         }
        //     }
        // }
        stage('Docker Image Build & Push'){

             steps{

                script{
                  withCredentials([string(credentialsId: 'docker', variable: 'dockerHub_pass')]) {
                  sh """
                  docker image build -t mohammedmubashshiralam/webapp:latest . 
                  docker login -u mohammedmubashshiralam -p ${dockerHub_pass} 
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
    }
}