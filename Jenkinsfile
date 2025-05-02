pipeline {
    agent any

    environment {
        AZ_CREDS = credentials('azure-service-principal')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/your/repo.git'
            }
        }

        stage('Run Ansible in Docker') {
            steps {
                script {
                    writeFile file: 'azure_creds.json', text: "${AZ_CREDS}"
                    def creds = readJSON file: 'azure_creds.json'
                    env.AZURE_SUBSCRIPTION_ID = creds.subscriptionId
                    env.AZURE_CLIENT_ID = creds.clientId
                    env.AZURE_SECRET = creds.clientSecret
                    env.AZURE_TENANT = creds.tenantId
                }
                sh '''
                    docker run --rm \
                      -v $(pwd):/ansible \
                      -v ~/.ssh:/root/.ssh:ro \
                      -e AZURE_SUBSCRIPTION_ID \
                      -e AZURE_CLIENT_ID \
                      -e AZURE_SECRET \
                      -e AZURE_TENANT \
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
