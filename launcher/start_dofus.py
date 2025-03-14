import configparser
import subprocess
import os

# Charger le fichier de configuration
config = configparser.ConfigParser()
config.read(os.path.join(os.path.dirname(__file__), "../config/settings.ini"))

# Récupérer le chemin de Dofus
dofus_path = config.get("DOFUS", "path", fallback="")

if os.path.exists(dofus_path):
    print("[INFO] Lancement de Dofus...")
    subprocess.Popen(dofus_path, shell=True)
else:
    print("[ERREUR] Fichier Dofus introuvable ! Vérifie le chemin dans config/settings.ini")
