import os
import sys

# Ajouter le dossier launcher au PATH pour importer les scripts
sys.path.append(os.path.join(os.path.dirname(__file__), "launcher"))

# Importer et exécuter le script de lancement
from start_dofus import subprocess

print("[INFO] Démarrage de l’application...")
subprocess.run(["python", "launcher/start_dofus.py"])
