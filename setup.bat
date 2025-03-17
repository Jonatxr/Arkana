@echo off
setlocal EnableDelayedExpansion

REM Nom unique basé sur date et heure actuelle
for /f "skip=1" %%x in ('wmic os get localdatetime') do set dt=%%x & goto continue
:continue
set "timestamp=%dt:~0,8%_%dt:~8,6%"
set "output_dir=build_%timestamp%"

echo ==========================================
echo       Création de l'exécutable Arkana
echo       Répertoire : %output_dir%
echo ==========================================
echo.

REM Vérification de PyInstaller
echo Vérification de PyInstaller...
pip show pyinstaller >nul 2>&1
IF ERRORLEVEL 1 (
    echo PyInstaller non trouvé. Installation en cours...
    pip install pyinstaller
) ELSE (
    echo PyInstaller est déjà installé.
)
echo.

REM Création de l'exécutable (prenant en compte launcher.py)
echo Création de l'exécutable en cours...
pyinstaller --onefile --windowed launcher\launcher.py

IF %ERRORLEVEL% EQU 0 (
    REM Création du dossier unique
    mkdir "%output_dir%"
    move "dist\launcher.exe" "%output_dir%\Arkana.exe"

    echo.
    echo ==========================================
    echo Exécutable créé avec succès dans :
    echo %output_dir%
    echo ==========================================
    explorer "%output_dir%"
) ELSE (
    echo Erreur lors de la création de l'exécutable.
    exit /b 1
)

REM Nettoyage des répertoires PyInstaller
rd /s /q build
rd /s /q dist
del /q *.spec >nul 2>&1

pause
