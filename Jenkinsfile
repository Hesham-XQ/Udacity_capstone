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

        stage('Set K8S Context'){
            steps {
                withAWS(credentials:'25967a97-5647-4269-a6cb-a88477ad3460'){
                    sh "kubectl config set-context eks-cluster@uda-cap.us-east-1.eksctl.io"
                }
            }
        }

        stage('Build Green Docker Image') {
            steps {
                sh 'docker build -t heshamxq/flask-app .'
            }
        }

        stage('Upload Green Image to Docker-Hub'){
            steps{
                sh 'docker login -u heshamxq -p Hpassvf@90'
                sh 'docker push heshamxq/flask-app'
            }
        }

        stage('Clean Up Green Image'){
            steps { 
                sh "docker rmi heshamxq/flask-app:latest" 
            }
        }

        stage('Green Deployment'){
            steps {
                withAWS(credentials:'25967a97-5647-4269-a6cb-a88477ad3460'){
                    sh "kubectl apply -f k8s/Green/green-deployment.yaml && kubectl apply -f k8s/Green/test-service.yaml"
                }
            }
        }

        stage('Test Green Deployment'){
            steps{
                input "Deploy to production?"
            }
        }

        stage('Switch Traffic To Green Deployment'){
            steps{
                withAWS(credentials:'25967a97-5647-4269-a6cb-a88477ad3460'){
                    sh "kubectl apply -f k8s/Green/green-service.yaml"
                }
            }
        }

        stage('Build Blue Docker Image') {
            steps {
                script{
                    blueDockerImage = docker.build "heshamxq/flask-app"
                }
            }
        }

        stage('Upload Blue Image to Docker-Hub'){
            steps{
                script{
                    docker.withRegistry('', docker-registery){
                        blueDockerImage.push()
                    }
                }
            }
        }

        stage('Clean Up Blue Image'){
            steps { 
                sh "docker rmi heshamxq/flask-app:latest" 
            }
        }

        stage('Blue Deployment'){
            steps {
                withAWS(credentials:'25967a97-5647-4269-a6cb-a88477ad3460'){
                    sh "kubectl apply -f k8s/Blue"
                }
            }
        }
    }
}