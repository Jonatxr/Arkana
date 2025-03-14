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

        stage('Déplacer ZIP vers /srv') {
            steps {
                sh '''
                sudo mv Arkana.zip /srv/Arkana.zip
                sudo chmod 644 /srv/Arkana.zip
                '''
            }
        }

        stage('Archivage ZIP') {
            steps {
                archiveArtifacts artifacts: '/srv/Arkana.zip', fingerprint: true
            }
        }
    }
}
