pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    environment {
        APP_VERSION = '1.0'  // Change cette valeur à chaque nouvelle version de l'application
    }

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
                sh """
                zip -r Arkana_v${env.APP_VERSION}_${env.BUILD_NUMBER}.zip . -x "*.git*" -x "venv/*"
                sudo cp Arkana_v${env.APP_VERSION}_${env.BUILD_NUMBER}.zip /srv/
                """
            }
        }

        stage('Archivage ZIP') {
            steps {
                archiveArtifacts artifacts: "Arkana_v${env.APP_VERSION}_${env.BUILD_NUMBER}.zip", fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build réussi : Arkana version ${env.APP_VERSION}, Build #${env.BUILD_NUMBER}"
        }
    }
}
