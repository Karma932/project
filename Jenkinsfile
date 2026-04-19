pipeline {
    agent { label 'tomcat' }   // Targets your Agent Node

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/Karma932/project.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh '''
                cp target/*.war /mnt/webapps/apache-tomcat-10.1.54/webapps/
                /mnt/webapps/apache-tomcat-10.1.54/bin/shutdown.sh || true
                /mnt/webapps/apache-tomcat-10.1.54/bin/startup.sh
                '''
            }
        }
    }
}
