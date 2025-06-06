pipeline {
    agent any

    stages {
        stage('Test') {
                steps {
                    sh 'node --test'
                }
            }

        stage('Docker') {
            steps {
                sh '''
                    docker build -t mynodeapp .

                    docker tag mynodeapp ttl.sh/mynodeapp:2h
                    docker push ttl.sh/mynodeapp:2h

                '''
            }
        }

         
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'test-id', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H docker >> ~/.ssh/known_hosts

                       ssh -i "$SSH_KEY" "$SSH_USER"@docker '

                            docker pull ttl.sh/mynodeapp:2h
                            docker stop mynodeapp || true
                            docker rm mynodeapp || true
                            docker run -d --name mynodeapp -p 4444:4444 ttl.sh/mynodeapp:2h
                        '
                    '''
                }
            }
        }
    }
}