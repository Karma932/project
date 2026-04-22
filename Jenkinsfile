pipeline {
    agent any

    tools {
        maven 'Maven-3'
    }

    environment {
        MAVEN_OPTS = '-Xmx512m'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Karma932/project.git', branch: 'master'
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'  // Skip tests to save memory
            }
        }

        stage('Docker Compose Up') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Deployment Verification') {
            steps {
                sh '''
                    echo "Waiting for Tomcat to start..."
                    for i in {1..30}; do
                        if curl -s http://localhost:8080 > /dev/null; then
                            echo "Tomcat is up!"
                            exit 0
                        fi
                        sleep 2
                    done
                    echo "Tomcat did not start in time"
                    exit 1
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker compose down -v'  // Removed --rmi all to save memory during cleanup
            }
        }
    }

    post {
        always {
            // Ensure cleanup even if build fails
            sh 'docker compose down -v || true'
        }
    }
}
