node {
     stage('Clone repository') {
         checkout scm
     }

     stage('Build image') {
        frontend = docker.build("lordofkangs/k8s_frontend", "./frontend/")
        backend = docker.build("lordofkangs/k8s_backend", "./backend/")
        mysql = docker.build("lordofkangs/k8s_mysql", "./mysql/")
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