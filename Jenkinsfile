pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sshagent(['github-ssh-key']) {
                    git branch: 'main', url: 'git@github.com:Jonatxr/Arkana.git'
                }
            }
        }

        stage('Préparation (ZIP)') {
            steps {
                sh '''
                zip -r Arkana.zip . -x "*.git*" -x "venv/*"
                '''
            }
        }

        stage('Archivage ZIP') {
            steps {
                archiveArtifacts artifacts: 'Arkana.zip', fingerprint: true
            }
        }
    }
}
