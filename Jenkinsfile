pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Karma932/project.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'tomcat-slave-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY target/LoginWebApp.war ec2-user@43.204.97.87:/mnt/servers/apache-tomcat-10.1.54/webapps/
                    '''
                }
            }
        }
    }
}
