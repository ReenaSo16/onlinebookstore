pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME' // Adjust to match your Maven name in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('sonar99') // Jenkins credentials for SonarQube token
        NEWRELIC_API_KEY = credentials('newrelic-api-key') // Jenkins Secret Text for New Relic
        APP_NAME = 'onlinebookstore' // Your New Relic App name
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning GitHub repository'
                git branch: 'main', url: 'https://github.com/ReenaSo16/onlinebookstore.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Java project with Maven'
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo ' Running unit tests'
                bat 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Running SonarQube analysis'
                withSonarQubeEnv('sonarscanner') {
                    bat '''mvn sonar:sonar ^
                        -Dsonar.projectKey=onlinebookstore ^
                        -Dsonar.projectName="Online Book Store" ^
                        -Dsonar.login=%SONAR_TOKEN%'''
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo ' Deploying WAR to Tomcat'
                deploy adapters: [tomcat9(
                    credentialsId: 'tomct9',
                    url: 'http://localhost:8085'
                )],
                contextPath: 'onlinebookstore',
                war: '**/onlinebookstore.war'
            }
        }

        stage('Notify New Relic') {
            steps {
                echo ' Sending deployment info to New Relic'
                bat """
                    curl -X POST https://api.newrelic.com/v2/applications/deployments.json ^
                    -H "X-Api-Key:%NEWRELIC_API_KEY%" ^
                    -H "Content-Type: application/json" ^
                    -d "{ \\"deployment\\": {
                        \\"revision\\": \\"%BUILD_NUMBER%\\",
                        \\"changelog\\": \\"Deployed from Jenkins Pipeline\\",
                        \\"description\\": \\"Automated Deployment via Jenkins\\",
                        \\"user\\": \\"Jenkins User\\",
                        \\"app_name\\": \\"%APP_NAME%\\" }}"
                """
            }
        }
    }

    post {
        success {
            echo '✅ Deployment pipeline completed successfully'
        }
        failure {
            echo '❌ Pipeline failed, check logs'
        }
    }
}
