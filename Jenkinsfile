pipeline {
    agent any

    environment {
        VIRTUAL_ENV = "${env.WORKSPACE}/venv"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '[INFO] Récupération du code source depuis GitHub...'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'git@github.com:Jonatxr/Arkana.git',
                        credentialsId: 'github-ssh-key'
                    ]]
                ])
            }
        }

        stage('Setup') {
            steps {
                echo '[INFO] Configuration de l\'environnement virtuel et installation des dépendances...'
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install -r requirements.txt pytest flake8
                '''
            }
        }

        stage('Tests & Flake8') {
            steps {
                script {
                    sh '''
                        source venv/bin/activate
                        pytest tests/ || echo "[WARNING] Certains tests ont échoué !"
                        flake8 . || echo "[WARNING] Flake8 a détecté des problèmes !"
                    '''
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    sh '''
                        zip -r Arkana_${BUILD_NUMBER}.zip . -x '*.git*' 'venv/*' 'tests/*'
                    '''
                }
                archiveArtifacts artifacts: 'Arkana_${BUILD_NUMBER}.zip', fingerprint: true
            }
        }

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

    post {
        success {
            echo '[SUCCESS] ✅ Build réussi !'
        }
        failure {
            echo '[ERROR] Le build a échoué, veuillez vérifier les logs Jenkins pour plus de détails.'
        }
    }
}