# Docker-360
## How to create Dockerfile, build image and push on DockerHub
--------------------
### 1. How to install docker.io:

```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/
apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker.io
```

### 2 .Start and Enable docker:

```
sudo systemctl start docker
sudo systemctl enable docker
```
### 3. Check version:
```
docker --version
```
### 4 .Create group and add user to the docker:
https://learn.microsoft.com/en-us/windows/wsl/wsl-config
```
sudo groupadd docker
sudo usermod -aG docker $USER
```

### 5. Build image:
Make sure you are in the folder where it is your Dockerfile

```
docker build -t toolbox:1 .
```
![Alt text](image.png)

### 6. Login to the DockerHub:
Generate your access token and use instaed of password
 
```
docker login -u <dockerhubusername>
```

### 7. Tag and build image to:

Build amd64 architectur:
```
docker tag toolbox:1 <username>/<repository_name>:<tag>
docker push <username>/<repository_name>:<tag>
```
Build, push Dokcer image and create new repo on DockerHub with two architectures(amdx64 and armx64) in one tag:

```
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64  -t username/imagename:tag   --push .
```
### 8.How to run image

```
docker pull <user>/<image>:tag
docker run -it <user>/<image>:tag
```
