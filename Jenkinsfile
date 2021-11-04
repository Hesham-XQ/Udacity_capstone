pipeline {
    environment{
        registryCredential = 'docker-hub' 
        greenDockerImage = '' 
        blueDockerImage = ''
    }
    agent any 
    stages {

        stage('Install Requirements'){
            steps{
                sh "pip3 install -r requirements.txt"
            }
        }

        stage('Lint Code'){
            steps {
                sh "bash ./run_pylint.sh"
            }
        }



        stage('Build Docker Image') {
            steps {
                sh 'docker build -t heshamxq/flask-app .'
            }
        }

        stage('Upload Image to Docker-Hub'){
            steps {
                  withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                      sh 'docker push heshamxq/flask-app'
                  }
              }
        }


        stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'awscred', region: 'us-east-1') {
                      sh "aws eks --region us-east-1 update-kubeconfig --name udacity-capstone"
                      sh "kubectl config use-context arn:aws:eks:us-east-1:559740661459:cluster/udacity-capstone"
                      sh "kubectl apply -f capstone-deploy.yaml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/capstone-flask-app-service"
                  }
              }
        }

        stage('Checking rollout') {
              steps{
                  echo 'Checking rollout...'
                  withAWS(credentials: 'awscred', region: 'us-east-1') {
                     sh "kubectl rollout status deployments/flask-app"
                  }
              }
        }
        stage("Cleaning up") {
              steps{
                    echo 'Cleaning up...'
                    sh "docker system prune"
              }
        }
    }
}