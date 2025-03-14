pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
        timeout(time: 30, unit: 'MINUTES') // Timeout pour éviter les jobs bloqués
    }

    environment {
        APP_VERSION = '1.0'
        ZIP_NAME = "Arkana_v${env.APP_VERSION}_${env.BUILD_NUMBER}.zip"
        VENV_DIR = "venv"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "[INFO] Récupération du code source depuis GitHub..."
                sshagent(['github-ssh-key']) {
                    git branch: 'main', url: 'git@github.com:Jonatxr/Arkana.git'
                }
            }
        }

        stage('Setup Environment') {
            steps {
                script {
                    echo "[INFO] Création de l'environnement virtuel..."
                    sh "python3 -m venv ${VENV_DIR}"
                    sh "source ${VENV_DIR}/bin/activate && pip install --upgrade pip setuptools wheel"
                    sh "source ${VENV_DIR}/bin/activate && pip install -r requirements.txt"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "[INFO] Exécution des tests avec pytest..."
                    sh "source ${VENV_DIR}/bin/activate && pytest tests/"
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    echo "[INFO] Vérification du code avec flake8..."
                    sh "source ${VENV_DIR}/bin/activate && flake8 --max-line-length=120 launcher/ app.py"
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    echo "[INFO] Compression du projet en ZIP..."
                    sh "rm -f /srv/${ZIP_NAME}" // Suppression des anciennes versions
                    sh "zip -r /srv/${ZIP_NAME} . -x \"venv/*\" \"*.git*\" \"__pycache__/*\""
                    echo "[SUCCESS] Archive créée: /srv/${ZIP_NAME}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo "[INFO] Suppression de l'environnement virtuel..."
                    sh "rm -rf ${VENV_DIR}"
                }
            }
        }

    }

    post {
        success {
            echo "[SUCCESS] Pipeline terminé avec succès !"
            // Exemple pour notification Slack (ajoute ton webhook dans Jenkins)
            // slackSend channel: '#devops', color: 'good', message: "Build #${env.BUILD_NUMBER} de Arkana réussi !"
        }

        failure {
            echo "[ERROR] Pipeline échoué !"
            // slackSend channel: '#devops', color: 'danger', message: "Build #${env.BUILD_NUMBER} de Arkana a échoué !"
        }
    }
}
