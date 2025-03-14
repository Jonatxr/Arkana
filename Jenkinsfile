pipeline {
  agent any
  
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/Jonatxr/Arkana.git'
      }
    }
    
    stage('Build Python App') {
      steps {
        sh '''
          python3 -m venv venv
          source venv/bin/activate
          pip install -r requirements.txt
          python setup.py build
          python setup.py sdist
        '''
      }
    }
    
    stage('Livraison Artefact') {
      steps {
        sshagent(['ssh-credential']) {
          sh 'scp dist/*.tar.gz jonathan@192.168.1.2000:/apps/Arkana/'
        }
      }
    }
  }
}
