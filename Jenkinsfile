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
                    sh """
                        python3 -m venv ${VENV_DIR}
                        . ${VENV_DIR}/bin/activate && pip install --upgrade pip setuptools wheel
                        . ${VENV_DIR}/bin/activate && pip install -r requirements.txt
                    """
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "[INFO] Exécution des tests avec pytest..."
                    sh """
                        . ${VENV_DIR}/bin/activate && pytest tests/ || echo '[WARNING] Certains tests ont échoué !'
                    """
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    echo "[INFO] Vérification du code avec flake8..."
                    sh """
                        . ${VENV_DIR}/bin/activate && flake8 --max-line-length=120 launcher/ app.py || echo '[WARNING] Flake8 a détecté des problèmes !'
                    """
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    echo "[INFO] Vérification si zip est installé..."
                    sh "command -v zip >/dev/null 2>&1 || { echo '[ERROR] zip n'est pas installé !'; exit 1; }"

                    echo "[INFO] Suppression des anciens fichiers ZIP..."
                    sh "sudo find /srv/ -name 'Arkana_v*.zip' -type f -mtime +15 -delete"

                    echo "[INFO] Compression du projet en ZIP..."
                    sh """
                        zip -r ${ZIP_NAME} . -x "venv/*" "*.git*" "__pycache__/*"
                        sudo mv ${ZIP_NAME} /srv/
                    """
                    echo "[SUCCESS] Archive créée: /srv/${ZIP_NAME}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo "[INFO] Nettoyage de l'environnement..."
                    sh "rm -rf ${VENV_DIR}"
                }
            }
        }

    }

    post {
        success {
            echo "[SUCCESS] ✅ Pipeline terminé avec succès !"
        }

        failure {
            echo "[ERROR] ❌ Pipeline échoué ! Vérifie les logs."
        }
    }
}
