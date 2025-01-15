pipeline {
    agent any
    stages {
        stage('### test ###') {
            steps {
                echo "Testing the application"
                echo "Executing pipeline for branch $BRANCH_NAME"
            }
        }

        stage('### build ###') {
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    echo "Building the application frontend_$BRANCH_NAME"
                    sh '''
                       cd ./frontend
                       docker build -t tishadev/time-app-frontend .
                       echo "Building the application backend_$BRANCH_NAME"
                       cd ../api
                       docker build -t tishadev/tishadev/time-app-api -f .
                    '''
                }
            }
        }

        stage('### pusching images to repo ###'){
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')])
                script{
                     sh "echo $PASS | docker login -u $USER --password-stdin"
                     sh 'docker push tishadev/time-app-frontend'
                     sh 'docker push tishadev/tishadev/time-app-api'
                }
            }
        }

        stage('deploy to prod') {
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                echo "Deploying the application $BRANCH_NAME"
                script {
                    sshagent(['ec2-server-key']) {
                        sh '''
                            echo "MYSQL_HOST=${env.MYSQL_HOST}" >> .env
                            echo "MYSQL_PORT=${env.MYSQL_PORT}" >> .env
                            echo "MYSQL_USER=${env.MYSQL_USER}" >> .env
                            echo "MYSQL_PASSWORD=${env.MYSQL_PASSWORD}" >> .env
                            echo "MYSQL_DB=${env.MYSQL_DB}" > .env
                        '''
                        sh '''
                            ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_IP} bash -c "mkdir -p ~/app"
                            scp ./.env ${env.REMOTE_USER}@${env.REMOTE_IP}:~/app
                            scp ./docker-compose-pub.yml ${env.REMOTE_USER}@${env.REMOTE_IP}:~/app
                            scp ./scripts/run.sh ${env.REMOTE_USER}@${env.REMOTE_IP}:~/app
                            ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_IP} bash -c "~/app/run.sh"
                        '''
                    }
                }
            }
        }

        stage('deploy to dev') {
            when {
                expression {
                    BRANCH_NAME == 'dev'
                }
            }
            steps {
                echo "Deploying the application $BRANCH_NAME"
                
            }
        }
    } 

    post {
        success {
            echo "Job is successful!"
        }
        failure {
            echo "Job is failed! Please check the logs for details."
        }
    }
}