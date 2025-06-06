pipeline {
    agent any

    stages {
        stage('Test') {
                steps {
                    sh 'node --test'
                }
            }
        
        // stage('Build') {
        //     steps {
        //         sh '''
        //             npm install
        //             npm test
        //         '''
        //     }
        // }

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

                        # Copy index.js and node_modules folder to the home directory
                        scp -i "$SSH_KEY" -r index.js node_modules "$SSH_USER"@target:/home/laborant/

                        # Copy the systemd service file to the home directory
                        scp -i "$SSH_KEY" main.service "$SSH_USER"@target:/home/laborant/


                        ssh -i "$SSH_KEY" "$SSH_USER"@target '
                            sudo mv /home/laborant/main.service /etc/systemd/system/main.service
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