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

                def readPomVersion = readMavenPom file: 'pom.xml'

                def nexusRepo =  readPomVersion.version.endsWith("SNAPSHOT") ? "maven-snapshot" : "maven-release"

                nexusArtifactUploader artifacts: 
                [[
                    artifactId: 'springboot',
                    classifier: '', 
                    file: 'target/Uber.jar', 
                    type: 'jar'
                    ]], 
                    credentialsId: 'd1d33924-ec59-4550-9dca-3c53c2750014', 
                    groupId: 'com.example', 
                    nexusUrl: '54.204.212.156:8081', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: nexusRepo, 
                    version: "${readPomVersion.version}"
            }
           }
       }
    }
}