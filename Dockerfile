FROM alpine
ARG ARCH
RUN ARCH = ${uname -m}\
if[ "$ARCH" == "x86_64" ];\
    TF_ARCH = "linux_amd64"\
    KUBECTL = "amd64"\
    IMAGE = " "\
elif[ "$ARCH" == "aarch64" ]; \
    TF_ARCH = "linux_arm64" \
    KUBECTL = "arm64"\
    IMAGE = "arm64v8/"\
else echo "Unknown architecture"\
    exit 1 \
fi


FROM ${IMAGE}ubuntu

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    USER=ndrobnjak \
    HOME=/home/$USER \
    PATH=/home/$USER/bin:$PATH

# Create a non-root user
RUN useradd -m -s /bin/bash $USER
RUN echo ${IMAGE} ${ARCH} ${KUBECTL} ${TF_ARCH}
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

#Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/1.5.2/terraform_1.5.2_'${TF_ARCH}'.zip && \
    unzip terraform_1.5.2_'${TF_ARCH}'.zip -d /usr/local/bin/ && \
    rm terraform_1.5.2_'${TF_ARCH}'.zip; 

# Install Kube
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ 

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