FROM ubuntu
ARG TERRAFORMVERSION="1.5.2"
ARG TARGETARCH

RUN echo "TARGETARCH": ${TARGETARCH}
RUN echo "$(uname -m)"

RUN if [ $(uname -m) == "x86_64" ]; then TF_ARCH="linux_amd64" KUBECTL="amd64" \
#Install Terraform for amd64
        curl -LO https://releases.hashicorp.com/terraform/${TERRAFORMVERSION}/terraform_${TERRAFORMVERSION}_${TF_ARCH}.zip \
        unzip terraform_${TERRAFORMVERSION}_'${TF_ARCH}'.zip -d /usr/local/bin/ \
        rm terraform_${TERRAFORMVERSION}_'${TF_ARCH}'.zip; \
#Install Kubernets for amd64                                          
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL}/kubectl" \
        chmod +x kubectl \
        mv kubectl /usr/local/bin/ ; \
    else TF_ARCH="linux_arm64" KUBECTL="arm64" \
#Install Terraform for arm64
        curl -LO https://releases.hashicorp.com/terraform/${TERRAFORMVERSION}/terraform_${TERRAFORMVERSION}_${TF_ARCH}.zip \
        unzip terraform_${TERRAFORMVERSION}_'${TF_ARCH}'.zip -d /usr/local/bin/ \
        rm terraform_${TERRAFORMVERSION}_'${TF_ARCH}'.zip;  \
#Install Kubernetes for arm64
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL}/kubectl" \
        chmod +x kubectl \
        mv kubectl /usr/local/bin/ ; \
    fi ; echo "error"
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    USER=ndrobnjak \
    HOME=/home/$USER \
    PATH=/home/$USER/bin:$PATH

# Create a non-root user
RUN useradd -m -u 1000  ${USER} && \
    echo "$USER ALL =(ALL) NOPASSWD: ALL" >> /etc/sudoers

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
    wget

# Install Ansible
RUN apt update && \
    apt install -y ansible && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set the non-root user
USER $USER

# Set the environment and aliases in .bashrc
RUN echo 'export PATH="/home/$USER/bin:$PATH"' >> /home/ndrobnjak/.bashrc && \
    echo 'alias ll="ls -alF"' >> /home/ndrobnjak/.bashrc && \
    echo 'alias tf="terraform"' >> /home/ndrobnjak/.bashrc && \
    echo 'alias k8s="kubectl"' >> /home/ndrobnjak/.bashrc && \
    echo 'alias ansible="ansible-playbook"' >> /home/ndrobnjak/.bashrc

# Define the command to run when the container starts
CMD ["/bin/bash"]