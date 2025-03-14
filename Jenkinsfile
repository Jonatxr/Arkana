pipeline {
    agent any

    stages {
        stage('Checkout Repo') {
            steps {
                sshagent(['github-ssh-key']) {
                    git branch: 'main', url: 'git@github.com:Jonatxr/Arkana.git'
                }
            }
        }

        stage('Build EXE with PyInstaller') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                pyinstaller --onefile app.py --name Arkana
                '''
            }
        }

        stage('Archive EXE') {
            steps {
                archiveArtifacts artifacts: 'dist/Arkana', fingerprint: true
            }
        }
    }
}
