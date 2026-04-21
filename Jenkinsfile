pipeline {
    agent any

    environment {
        DOCKER_NETWORK = 'app-network'
        MYSQL_CONTAINER = 'mysql-db'
        TOMCAT_CONTAINER = 'tomcat-server'
        MYSQL_ROOT_PASSWORD = 'mysecretpassword'
        MYSQL_DATABASE = 'appdb'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Karma932/project.git', branch: 'master'
            }
        }

        stage('Network') {
            steps {
                sh "docker network inspect ${DOCKER_NETWORK} || docker network create ${DOCKER_NETWORK}"
            }
        }

        stage('MySQL') {
            steps {
                sh "docker rm -f ${MYSQL_CONTAINER} 2>/dev/null || true"
                sh """
                    docker run -d \
                        --name ${MYSQL_CONTAINER} \
                        --network ${DOCKER_NETWORK} \
                        -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                        -e MYSQL_DATABASE=${MYSQL_DATABASE} \
                        mysql:latest
                """
                sleep 30
            }
        }

        stage('Schema') {
            steps {
                sh "docker exec -i ${MYSQL_CONTAINER} mysql -uroot -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < correct_schema.sql"
            }
        }

        stage('Build') {
            steps {
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

        stage('Tomcat') {
            steps {
                script {
                    def warFile = findFiles(glob: 'target/*.war')[0].path
                    sh "docker rm -f ${TOMCAT_CONTAINER} 2>/dev/null || true"
                    sh """
                        docker run -d \
                            --name ${TOMCAT_CONTAINER} \
                            --network ${DOCKER_NETWORK} \
                            -p 8080:8080 \
                            tomcat:latest
                    """
                    sleep 10
                    sh "docker cp ${warFile} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/ROOT.war"
                }
            }
        }

        stage('Verify') {
            steps {
                sh """
                    sleep 20
                    curl --fail http://localhost:8080/
                """
            }
        }
    }
}
