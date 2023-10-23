pipeline{
    agent any

    environment {
        dockerHubRegistry = 'lordofkangs'
        dockerHubRegistryCredential = 'docker-hub'
        githubCredential = 'k8s_manifest_git'
        gitEmail = 'lordofkangs@naver.com'
        gitName = 'mgKang3646'
        imageFrontend = 'k8s_frontend'
        imageBackend = 'k8s_backend'
        imageMysql= 'k8s_mysql'
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
                sh "docker build -t ${dockerHubRegistry}/${imageFrontend}:${currentBuild.number} ./frontend"
                sh "docker build -t ${dockerHubRegistry}/${imageFrontend}:latest ./frontend"

                sh "docker build -t ${dockerHubRegistry}/${imageBackend}:${currentBuild.number} ./backend"
                sh "docker build -t ${dockerHubRegistry}/${imageBackend}:latest ./backend"

                sh "docker build -t ${dockerHubRegistry}/${imageMysql}:${currentBuild.number} ./mysql"
                sh "docker build -t ${dockerHubRegistry}/${imageMysql}::latest ./mysql"
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
                    sh "docker push ${dockerHubRegistry}/${imageFrontend}:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/${imageFrontend}:latest"

                    sh "docker push ${dockerHubRegistry}/${imageBackend}:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/${imageBackend}:latest"

                    sh "docker push ${dockerHubRegistry}/${imageMysql}:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}/${imageMysql}:latest"

                    sleep 10 /* Wait uploading */
                }
            }
            post {
                    failure {
                      echo 'Docker Image Push failure !'
                      sh "docker rmi ${dockerHubRegistry}/${imageFrontend}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageFrontend}:latest"

                      sh "docker rmi ${dockerHubRegistry}/${imageBackend}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageBackend}:latest"

                      sh "docker rmi ${dockerHubRegistry}/${imageMysql}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageMysql}:latest"
                    }
                    success {
                      echo 'Docker image push success !'
                      sh "docker rmi ${dockerHubRegistry}/${imageFrontend}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageFrontend}:latest"

                      sh "docker rmi ${dockerHubRegistry}/${imageBackend}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageBackend}:latest"

                      sh "docker rmi ${dockerHubRegistry}/${imageMysql}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}/${imageMysql}:latest"
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

                    sh "git config --global user.email ${gitEmail}"
                    sh "git config --global user.name ${gitName}"

                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./mysql-db/values.yaml"
                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./nodejs-backend/values.yaml"
                    sh "sed -i 's/tag:.*\$/tag: ${currentBuild.number}/g' ./react-frontend/values.yaml"
                    
                    sh "helm package react-frontend"
                    sh "helm package nodejs-backend"
                    sh "helm package mysql-db"
                    sh "helm repo index ./"

                    sh "git add ."
                    sh "git commit -m '[UPDATE] k8s ${currentBuild.number} image versioning'"



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