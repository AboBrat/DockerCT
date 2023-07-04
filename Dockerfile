FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    USER=ndrobnjak \
    HOME=/home/$USER \
    PATH=/home/$USER/bin:$PATH

# Create a non-root user
RUN useradd -m -s /bin/bash $USER

# Install tools
RUN apt-get update && \
    apt-get install -y \
    mc \
    git \
    vim \
    curl \
    wget \
    htop \
    tmux \
    nano \
    awscli \
    neofetch \
    docker.io \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    libssl-dev libffi-dev \
    mc \
    git \
    vim \
    curl \
    wget \
    htop \
    tmux \
    nano \
    awscli \
    neofetch \
    docker.io \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    libssl-dev libffi-dev 

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip \
    && unzip terraform_0.15.4_linux_amd64.zip \
    && mv terraform $HOME/bin \
    && rm terraform_0.15.4_linux_amd64.zip

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl $HOME/bin

# Install Ansible
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip install ansible

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