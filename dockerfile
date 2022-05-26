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

