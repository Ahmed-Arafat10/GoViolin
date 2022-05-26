pipeline {
 // agent {label "GoViolin"}
agent any
    stages {
        stage('Preparation') {
            steps {
               git 'https://github.com/Ahmed-Arafat10/GoViolin.git'
                  }
        
                              }
      
         stage('Build Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh """
                docker build . -f dockerfile -t ahmedarafat10/goviolin:latest
                """
            }
        }
        
        }   

         stage('Depoly') {
            steps {
                   sh """
                 docker container run -id -p 1115:8080 ahmedarafat10/goviolin:latest go run . 
                """
                }
        }   
      
         stage('Notification') {
                       steps {
              sh " ls "
                  }
                 post{
                      success{
                        slackSend(color:"#b1ff00",message: "pipeline is Deployed successfully :)")//Green
                        }
                        // failure not for syntax errors in scrip , its as for example $ docker command in pipeline that dont installed in it docker CLI
                        failure{
                        slackSend(color:"#ff0000",message: "pipeline failed to be debloyed :( ")//Red
                        } 
        }
        
        }   

     
      
    }
}
