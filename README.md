
# GoViolin

GoViolin is a web app written in Go that helps with violin practice.

Currently hosted on Heroku at https://go-violin.herokuapp.com/

GoViolin allows practice over both 1 and 2 octaves.

Contains:
* Major Scales
* Harmonic and Melodic Minor scales
* Arpeggios
* A set of two part scale duet melodies by Franz Wohlfahrt

# Output
<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/1.png" />

## Pipeline Is Built Successfully In Jenkins Dashboard


<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/2.png" />
<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/6.png" />
<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/7.png" />


## GoViolin Website Is Hosted On Port 1114

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/3.png" />

## A Message Is Sent To Slack To Notify That Pipeline Is Deployed Successfully

## List Docker Containers On The Device

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/4.png" />

## dockerfile In Vs Code

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/5.png" />

## Or you can Shorten the dockerfile to be like that:

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/5-5.png" />

## Jenkinsfile In Vs Code

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/8.png" />

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/9.png" />

## You Can See That Jenkins Has Created The Docker Image & It Is Ready To Be Pushed To Dockerhub

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/10.png" />

## Image Is Pushed To Dockerhub By Jenkins Pipeline

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/12.png" />

## GoViolin Is Deployed Successfully In Console Output 

<img align="center" title="DevOps" alt="DevOps" width="100%" src="/Screenshots/11.png" />


# Setps

## first create a docker image of jenkins that can run docker cli [to be able to write docker command in jenkins] 
```
# Dockerfile with jenkins image that modifiy it to have Docker client CLI  
FROM jenkins/jenkins:lts
USER root
#install docker client
RUN apt-get update -qq
RUN apt-get install -qq apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update -qq \
        && apt-get install docker-ce -y
RUN usermod -aG docker jenkins
```
## then create a docker container from that image
```
sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -id -p 9090:8080 myjenkins:v1
```
## now go to jenkins and after finishing the configration install ```slack plugin``` and add ```dockerhub``` credintial information in jenkins dashborad

then in GoViolin directory add ``` dockerfile ```
```
FROM golang:1.16-alpine
WORKDIR /GoViolin
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY css/ css/ 
COPY img/ img/ 
COPY mp3/ mp3/ 
COPY templates/ templates/ 
COPY vendor/ vendor/ 
COPY * ./ 
#RUN go run main.go 
# EXPOSE 8080
# CMD [go run main.go]
```
then add ``` Jenkinsfile ```
```
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
              stage('Push Image') {
               steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
               
   
                sh """
                 docker login -u ${USERNAME}  -p ${PASSWORD}
                / docker push ahmedarafat10/goviolin:latest
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
```
## then create a pipeline in jenkins then build it
