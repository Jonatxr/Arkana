pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    environment {
        APP_VERSION = '1.0'  // Change cette valeur à chaque nouvelle version de l'application
        ZIP_NAME = "Arkana_v${env.APP_VERSION}_${env.BUILD_NUMBER}.zip"
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
                # Vérifier si zip est installé
                if ! command -v zip &> /dev/null; then
                    echo "❌ Erreur : zip n'est pas installé !"
                    exit 1
                fi

                # Supprimer les anciens ZIP dans /srv pour éviter l'encombrement
                sudo find /srv/ -name 'Arkana_v*.zip' -type f -mtime +15 -delete

                # Création de l'archive ZIP
                zip -r ${ZIP_NAME} . -x "*.git*" -x "venv/*"

                # Déplacer l'archive dans /srv/ avec gestion d'erreur
                if sudo cp ${ZIP_NAME} /srv/; then
                    echo "✅ ZIP déplacé avec succès dans /srv/"
                else
                    echo "❌ Échec du déplacement du ZIP !"
                    exit 1
                fi
                """
            }
        }

        stage('Archivage ZIP') {
            steps {
                archiveArtifacts artifacts: "${ZIP_NAME}", fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build réussi : Arkana version ${env.APP_VERSION}, Build #${env.BUILD_NUMBER}"
        }
        failure {
            echo "❌ Échec du build ! Vérifie les logs."
        }
    }
}
