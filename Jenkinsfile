cat > Jenkinsfile << 'EOF'
pipeline {
    agent any

    environment {
        DOCKER_NETWORK = 'app-network'
        MYSQL_CONTAINER = 'mysql-db'
        TOMCAT_CONTAINER = 'tomcat-server'
        APP_REPO = 'https://github.com/Karma932/project.git'
        MYSQL_ROOT_PASSWORD = 'mysecretpassword'
        MYSQL_DATABASE = 'appdb'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: APP_REPO, branch: 'main'
            }
        }

        stage('Setup Docker Network') {
            steps {
                script {
                    sh "docker network inspect ${DOCKER_NETWORK} || docker network create ${DOCKER_NETWORK}"
                }
            }
        }

        stage('Start MySQL Database') {
            steps {
                script {
                    sh """
                        docker run -d \
                            --name ${MYSQL_CONTAINER} \
                            --network ${DOCKER_NETWORK} \
                            -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                            -e MYSQL_DATABASE=${MYSQL_DATABASE} \
                            mysql:latest
                    """
                    echo 'Waiting for MySQL to start...'
                    sleep time: 30, unit: 'SECONDS'
                }
            }
        }

        stage('Initialize Database Schema') {
            steps {
                script {
                    if (fileExists('correct_schema.sql')) {
                        sh "docker exec -i ${MYSQL_CONTAINER} mysql -uroot -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < correct_schema.sql"
                        echo "Database schema loaded successfully."
                    } else {
                        error "Database schema file 'correct_schema.sql' not found in the workspace."
                    }
                }
            }
        }

        stage('Build Application with Maven') {
            steps {
                script {
                    sh """
                        docker run --rm \
                            -v maven-repo:/root/.m2 \
                            -v \${WORKSPACE}:/workspace \
                            -w /workspace \
                            maven:3-openjdk-11 \
                            mvn clean package
                    """
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    def warFile = findFiles(glob: 'target/*.war')[0].path
                    sh """
                        docker run -d \
                            --name ${TOMCAT_CONTAINER} \
                            --network ${DOCKER_NETWORK} \
                            -p 8080:8080 \
                            tomcat:latest
                    """
                    echo 'Waiting for Tomcat to start...'
                    sleep time: 10, unit: 'SECONDS'
                    sh """
                        docker cp ${warFile} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/ROOT.war
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                        echo 'Waiting for application to deploy...'
                        sleep time: 20, unit: 'SECONDS'
                        curl --fail http://localhost:8080/
                    """
                    echo 'Application is up and running!'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished. Containers are left running for inspection.'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
EOF
