pipeline {
    agent any

    stages {
        stage('Test') {
                steps {
                    sh 'node --test'
                }
            }

        // stage('Docker') {
        //     steps {
        //         sh '''
        //             docker build -t mynodeapp .

        //             docker tag myapp ttl.sh/mynodeapp:2h
        //             docker push ttl.sh/mynodeapp:2h

        //         '''
        //     }
        // }

         
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'test-id', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H target >> ~/.ssh/known_hosts

                        ssh -i "$SSH_KEY" "$SSH_USER"@target 'sudo systemctl stop main.service || true'

                        scp -i "$SSH_KEY" index.js "$SSH_USER"@target:/home/$SSH_USER/:
                        scp -i "$SSH_KEY" main.service "$SSH_USER"@target:

                        ssh -i "$SSH_KEY" "$SSH_USER"@target '
                            sudo mv ~/main.service /etc/systemd/system/main.service
                            sudo systemctl daemon-reload
                            sudo systemctl enable main.service
                            sudo systemctl restart main.service
                        '
                    '''
                }
            }
        }
    }
}