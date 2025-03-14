pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    environment {
        APP_VERSION = '1.0'
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
                echo \"📂 Localisation de zip :\"
                which zip || { echo \"❌ zip n'est pas installé !\"; exit 1; }

                if [ ! -w /srv/ ]; then
                    echo \"❌ Erreur : Jenkins n'a pas les permissions en écriture sur /srv/\"
                    exit 1
                fi

                # Supprimer les anciens ZIP (sans attendre de mot de passe)
                sudo -n find /srv/ -name 'Arkana_v*.zip' -type f -mtime +15 -delete || echo \"⚠ Impossible de nettoyer /srv/\"

                # Création de l'archive ZIP
                zip -r ${ZIP_NAME} . -x \"*.git*\" -x \"venv/*\"

                if [ ! -f ${ZIP_NAME} ]; then
                    echo \"❌ Erreur : L'archive ZIP n'a pas été créée !\"
                    exit 1
                fi

                ls -lh ${ZIP_NAME}

                # Déplacer l'archive sans demande de mot de passe
                sudo -n cp ${ZIP_NAME} /srv/ || { echo \"❌ Erreur de copie vers /srv/\"; exit 1; }
                echo \"✅ ZIP déplacé avec succès dans /srv/\"
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
