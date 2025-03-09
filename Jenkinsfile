pipeline {
    agent any

    stages {
        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhubcredential', variable: 'DOCKER_TOKEN')]) {
                    sh 'echo $DOCKER_TOKEN | docker login -u sadioci2 --password-stdin'
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'dev', 
                    url: 'https://github.com/sadioci2/book-reminder.git'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose up -d --build'
                sh 'docker images'
            }
        }

        stage('Test Image') {
            steps {
                sh '''
                    docker run --rm -v "$PWD:/app" -w /app practice_web:latest sh -c "rm -f tmp/pids/server.pid && bundle install && bundle exec rspec"
                    docker ps
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push practice_web:latest'
            }
        }
    }

    post {
        success {
            echo "✅ Build and deployment successful!"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
