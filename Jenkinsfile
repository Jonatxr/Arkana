pipeline {
  agent any

  stages {

    stage('Clone Git Repo') {
      steps {
        sshagent(['git-ssh-key']) {
          git 'git@github.com:jonatxr/Arkana.git'
        }
      }
    }

    stage('Build .exe with PyInstaller') {
      steps {
        sh '''
          python3 -m venv venv
          source venv/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt

          # Générer l'exécutable Windows (.exe)
          pyinstaller --onefile --windowed app.py
        '''
      }
    }

    stage('Livrer Artefact') {
      steps {
        archiveArtifacts artifacts: 'dist/*.exe', fingerprint: true
      }
    }

  }
}
