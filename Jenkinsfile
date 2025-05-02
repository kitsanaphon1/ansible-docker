pipeline {
    agent any

    environment {
        AZ_CREDS = credentials('azure-service-principal')  // ต้องสร้างใน Jenkins Credentials แบบ Secret Text (JSON)
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'test', url: 'https://github.com/kitsanaphon1/ansible-test-docker.git'
            }
        }

        stage('Run Ansible in Docker') {
            steps {
                script {
                    writeFile file: 'azure_creds.json', text: "${AZ_CREDS}"
                }
                sh '''
                    docker run --rm \
                      -v $(pwd):/ansible \
                      -v ~/.ssh:/root/.ssh:ro \
                      -e AZURE_SUBSCRIPTION_ID=$(jq -r .subscriptionId azure_creds.json) \
                      -e AZURE_CLIENT_ID=$(jq -r .clientId azure_creds.json) \
                      -e AZURE_SECRET=$(jq -r .clientSecret azure_creds.json) \
                      -e AZURE_TENANT=$(jq -r .tenantId azure_creds.json) \
                      ansible-azure \
                      ansible-playbook create-vm.yml
                '''
            }
        }
    }

    post {
        always {
            sh 'rm -f azure_creds.json'
        }
    }
}
