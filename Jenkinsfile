pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/Karma932/project.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh '''
                WAR_FILE=$(ls target/*.war | head -n 1)
                cp $WAR_FILE /mnt/webapps/apache-tomcat-10.1.54/webapps/project.war
                /mnt/webapps/apache-tomcat-10.1.54/bin/shutdown.sh || true
                /mnt/webapps/apache-tomcat-10.1.54/bin/startup.sh
                '''
            }
        }
    }
}
