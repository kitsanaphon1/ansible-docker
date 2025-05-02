# Dockerfile
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl gnupg unzip sshpass git \
    && pip install --no-cache-dir ansible \
    && ansible-galaxy collection install azure.azcollection \
    && pip install --no-cache-dir \
        azure-cli \
        msrestazure \
        azure-mgmt-compute \
        azure-mgmt-network \
        azure-mgmt-resource \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["ansible", "--version"]
