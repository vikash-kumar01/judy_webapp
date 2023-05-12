pipeline{

    agent any

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
    }
}