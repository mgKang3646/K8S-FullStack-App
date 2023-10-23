node {
     stage('Clone repository') {
         checkout scm
     }
     stage('Build image') {
        frontend = docker.build("lordofkangs/frontend", "./frontend/")
        backend = docker.build("lordofkangs/backend", "./backend/")
        mysql = docker.build("lordofkangs/mysql", "./mysql/")
     }
     stage('Push image') {
         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
             frontend.push("${env.BUILD_NUMBER}")
             frontend.push("latest")

             backend.push("${env.BUILD_NUMBER}")
             backend.push("latest")

             mysql.push("${env.BUILD_NUMBER}")
             mysql.push("latest")
         }
     }
}