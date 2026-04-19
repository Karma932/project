pipeline {
    agent { label 'tomcat' }   // Targets your Agent Node

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/your-org/your-repo.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                // Copy WAR file to Tomcat webapps directory
                sh '''
                cp target/*.war /mnt/webapps/apache-tomcat-10.1.54/webapps/
                /mnt/webapps/apache-tomcat-10.1.54/bin/shutdown.sh || true
                /mnt/webapps/apache-tomcat-10.1.54/bin/startup.sh
                '''
            }
        }
    }
}
