pipeline{
    agent any

    environment {
        dockerHubRegistry = 'lordofkangs'
        dockerHubRegistryCredential = 'docker-hub'
        githubCredential = 'k8s_manifest_git'
    }

    stages {
        stage('check out application git branch'){
            steps {
                checkout scm
            }
            post {
                failure {
                    echo 'repository checkout failure'
                }
                success {
                    echo 'repository checkout success'
                }
            }
        }

        stage('docker image build'){
            steps{
                sh "docker build -t ${dockerHubRegistry}/frontend:${currentBuild.number} ./frontend"
                sh "docker build -t ${dockerHubRegistry}/frontend:latest ./frontend"

                sh "docker build -t ${dockerHubRegistry}/backend:${currentBuild.number} ./backend"
                sh "docker build -t ${dockerHubRegistry}/backend:latest ./backend"

                sh "docker build -t ${dockerHubRegistry}/mysql:${currentBuild.number} ./mysql"
                sh "docker build -t ${dockerHubRegistry}/mysql:latest ./mysql"
            }
            post {
                    failure {
                      echo 'Docker image build failure !'
                    }
                    success {
                      echo 'Docker image build success !'
                    }
            }
        }
        stage('Docker Image Push') {
            steps {
                withDockerRegistry([ credentialsId: dockerHubRegistryCredential, url: "" ]) {
                    sh "docker push ${dockerHubRegistry}/frontend:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/frontend:latest"

                    sh "docker push ${dockerHubRegistry}/backend:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/backend:latest"

                    sh "docker push ${dockerHubRegistry}/mysql:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/mysql:latest"

                    sleep 10 /* Wait uploading */
                }
            }
            post {
                    failure {
                      echo 'Docker Image Push failure !'
                      sh "docker rmi ${dockerHubRegistry}/frontend:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/frontend:latest"

                      sh "docker rmi ${dockerHubRegistry}/backend:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/backend:latest"

                      sh "docker rmi ${dockerHubRegistry}/mysql:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/mysql:latest"
                    }
                    success {
                      echo 'Docker image push success !'
                      sh "docker rmi ${dockerHubRegistry}/frontend:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/frontend:latest"

                      sh "docker rmi ${dockerHubRegistry}/backend:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/backend:latest"

                      sh "docker rmi ${dockerHubRegistry}/mysql:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/mysql:latest"
                    }
            }
        }
        stage('K8S Manifest Update') {
            steps {
                sh "ls"
                sh 'mkdir -p gitOpsRepo'
                dir("gitOpsRepo")
                {
                    git branch: "main",
                    credentialsId: githubCredential,
                    url: 'https://github.com/mgKang3646/Helm-Repository.git'

                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./mysql-db/values.yaml"
                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./nodejs-backend/values.yaml"
                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./react-frontend/values.yaml"

                    sh "git add ."
                    sh "git commit -m '[UPDATE] k8s ${currentBuild.number} image versioning'"
                    sh "git config --global user.email lordofkangs@naver.com"
                    sh "git config --global user.name mgKang3646"

                    

                    withCredentials([gitUsernamePassword(credentialsId: githubCredential,
                                     gitToolName: 'git-tool')]) {
                        sh "git remote set-url origin https://github.com/mgKang3646/Helm-Repository.git"
                        sh "git push -u origin main"
                    }
                }
            }
            post {
                    failure {
                      echo 'K8S Manifest Update failure !'
                    }
                    success {
                      echo 'K8S Manifest Update success !'
                    }
            }
        }

    }
}