pipeline {
    agent { label 'jenkins-agent' }

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/krishnamonani/jenkins-terraform-ansible-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                    sh 'terraform output ec2_public_ip > ../ansible/instance_ip.txt'
                }
            }
        }

        stage('Ansible Provision') {
            steps {
                dir('ansible') {
                    // Use the 'sshagent' wrapper to securely provide the SSH key
                    sshagent(credentials: ['vpc-test-key']) {
                        sh '''
                        EC2_IP=$(cat instance_ip.txt)
                        echo "[ec2_instance]" > inventory.ini
                        # You no longer need to specify the private key file here!
                        # Ansible will automatically use the key from sshagent.
                        echo "$EC2_IP ansible_user=ubuntu" >> inventory.ini
                        cat inventory.ini
                        '''

                        // Run Ansible playbook
                        // The -i flag is for inventory
                        sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check console output.'
        }
    }
}
