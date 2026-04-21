pipeline {
    agent { label 'tomcat' }

    environment {
        DB_CREDS = credentials('DB_CREDS')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Karma932/project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Update Config') {
            steps {
                sh '''
                echo "db.username=$DB_CREDS_USR" > src/main/resources/application.properties
                echo "db.password=$DB_CREDS_PSW" >> src/main/resources/application.properties
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['SLAVE_SSH_KEY']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no target/*.war ec2-user@172.31.14.25:/mnt/webapps/
                    ssh ec2-user@172.31.14.25 "sudo systemctl restart tomcat"
                    '''
                }
            }
        }
    }
}
