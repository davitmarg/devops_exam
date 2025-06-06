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
                withCredentials([string(credentialsId: 'k8s-token', variable: 'K8S_TOKEN')]) {
                    sh '''
                        kubectl config set-cluster my-cluster --server=https://k8s:6443 --insecure-skip-tls-verify=true
                        kubectl config set-credentials jenkins --token=$K8S_TOKEN
                        kubectl config set-context jenkins-context --cluster=my-cluster --user=jenkins
                        kubectl config use-context jenkins-context

                        kubectl apply -f definition.yaml
                    '''
                }
            }
        }
    }
}