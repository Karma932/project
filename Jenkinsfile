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

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
    }
}
