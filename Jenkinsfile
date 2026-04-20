pipeline {
    agent any

    environment {
        DB_CREDS = credentials('DB_CREDS')
        DB_URL = "jdbc:mysql://database-1.ctama2ma2nqr.ap-south-1.rds.amazonaws.com:3306/mysql"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
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
