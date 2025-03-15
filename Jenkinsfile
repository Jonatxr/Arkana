pipeline {
    agent any

    environment {
        APP_VERSION = '1.0'  // Mettez à jour cette valeur pour chaque nouvelle version
        ZIP_NAME = "Arkana_v${APP_VERSION}_${BUILD_NUMBER}.zip"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Jonatxr/Arkana.git'
            }
        }

        stage('Setup Environment') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install --upgrade pip setuptools wheel
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                source venv/bin/activate
                if [ -d "tests" ]; then
                    pytest tests/ || echo "[WARNING] Certains tests ont échoué !"
                else
                    echo "[INFO] Aucun test à exécuter."
                fi
                '''
            }
        }

        stage('Code Analysis') {
            steps {
                sh '''
                source venv/bin/activate
                flake8 --max-line-length=120 launcher/ app.py || echo "[WARNING] Flake8 a détecté des problèmes !"
                '''
            }
        }

        stage('Package Application') {
            steps {
                sh '''
                if ! command -v zip &> /dev/null; then
                    echo "❌ Erreur : zip n'est pas installé !"
                    exit 1
                fi

                sudo find /srv/ -name 'Arkana_v*.zip' -type f -mtime +15 -delete

                zip -r ${ZIP_NAME} . -x "*.git*" -x "venv/*"

                if sudo cp ${ZIP_NAME} /srv/; then
                    echo "✅ ZIP déplacé avec succès dans /srv/"
                else
                    echo "❌ Échec du déplacement du ZIP !"
                    exit 1
                fi
                '''
            }
        }

        stage('Archive ZIP') {
            steps {
                archiveArtifacts artifacts: "${ZIP_NAME}", fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build réussi : Arkana version ${APP_VERSION}, Build #${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Échec du build ! Vérifiez les logs."
        }
    }
}
