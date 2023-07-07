FROM ubuntu
ARG TERRAFORMVERSION="1.5.2"
ARG TARGETARCH
ARG USER=ndrobnjak
RUN echo "TARGETARCH": ${TARGETARCH}
RUN echo "$(uname -m)"

# Install tools
RUN apt-get update && \
    apt-get install -y \
    vim \
    curl \
    nano \
    apt-transport-https \
    software-properties-common \
    git \
    vim \
    curl \
    unzip \
    python3-pip \
    wget

RUN if [ $(uname -m) == "x86_64" ]; then ARCH="amd64"; \ 
        #Install Terraform for amd64
        wget https://releases.hashicorp.com/terraform/${TERRAFORMVERSION}/terraform_${TERRAFORMVERSION}_linux_amd64.zip; \
        unzip terraform_${TERRAFORMVERSION}_linux_amd64.zip -d /usr/local/bin/;\
        rm terraform_${TERRAFORMVERSION}_'${TF_ARCH}'.zip; \
        #Install Kubernets for amd64                                          
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
        install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
    else [ $(uname -m) == "aarch64" ]; \
        #Install Terraform for arm64
        wget https://releases.hashicorp.com/terraform/${TERRAFORMVERSION}/terraform_${TERRAFORMVERSION}_linux_arm64.zip; \
        unzip terraform_${TERRAFORMVERSION}_linux_arm64.zip -d /usr/local/bin/; \
        rm terraform_${TERRAFORMVERSION}_linux_arm64.zip; \
        #Install Kubernetes for arm64
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; \
        install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
    fi ; \
        echo "Unknow architecture"


RUN pip3 install ansible

# Create a non-root user
RUN useradd -m -s /bin/bash ${USER}

# Set the non-root user
USER ${USER}
WORKDIR /home/$USER

# Define the command to run when the container starts
CMD ["/bin/bash"]