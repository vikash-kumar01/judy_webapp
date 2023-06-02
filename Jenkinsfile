pipeline{

    agent any 

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
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 996864587356.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t webapp .
                    docker tag webapp:latest 996864587356.dkr.ecr.us-east-1.amazonaws.com/webapp:latest
                    docker push 996864587356.dkr.ecr.us-east-1.amazonaws.com/webapp:latest
                    """
                }
            }
        }
    }
}