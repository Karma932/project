pipeline {
    agent any

    tools {
        maven 'Maven-3'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Karma932/project.git', branch: 'master'
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Compose Up') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Deployment Verification') {
            steps {
                script {
                    // Wait for Tomcat to be ready (max 30 seconds)
                    sh '''
                        echo "Waiting for Tomcat to start..."
                        for i in {1..30}; do
                            if curl -s http://localhost:8080 > /dev/null; then
                                echo "Tomcat is up!"
                                exit 0
                            fi
                            sleep 1
                        done
                        echo "Tomcat did not start in time"
                        exit 1
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker compose down --rmi all -v'
            }
        }
    }
}
