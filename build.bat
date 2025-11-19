@echo off
setlocal

REM ============================================================
REM Configuration
REM ============================================================

set APP_NAME=TestFramework
set TOMCAT_HOME=C:\Program Files\Tomcat\apache-tomcat-11.0.13
set TOMCAT_WEBAPPS=%TOMCAT_HOME%\webapps
set SRC_DIR=src\main\java
set WEB_DIR=src\main\webapp
set LIB_DIR=lib
set BUILD_DIR=build
set WAR_FILE=%APP_NAME%.war

echo -----------------------------
echo 🔧 Nettoyage du dossier build
echo -----------------------------

if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%\WEB-INF\classes"


REM ============================================================
REM Compilation Java
REM ============================================================

echo -----------------------------
echo 🔨 Compilation des servlets…
echo -----------------------------

for /r "%SRC_DIR%" %%f in (*.java) do (
    javac -cp "%LIB_DIR%\servlet-api.jar;%LIB_DIR%\Framework.jar" ^
        -d "%BUILD_DIR%\WEB-INF\classes" ^
        -source 21 -target 21 ^
        "%%f"
)


REM ============================================================
REM Copie des ressources web
REM ============================================================

echo -----------------------------
echo 📦 Copie des fichiers web
echo -----------------------------

REM Copier tout le contenu de webapp (pages, css, WEB-INF, ...)
if exist "%WEB_DIR%" (
    xcopy "%WEB_DIR%\*" "%BUILD_DIR%\" /E /I /Y >nul
)

REM Copier libs vers le WAR
if not exist "%BUILD_DIR%\WEB-INF\lib" mkdir "%BUILD_DIR%\WEB-INF\lib"
if exist "%LIB_DIR%\*.jar" (
    copy "%LIB_DIR%\*.jar" "%BUILD_DIR%\WEB-INF\lib\" >nul
)

REM Supprimer les API servlet embarquées (doivent rester dans le conteneur)
pushd "%BUILD_DIR%\WEB-INF\lib" 2>nul
if "%ERRORLEVEL%"=="0" (
    del /q servlet-api.jar 2>nul
    del /q jakarta.servlet-api-*.jar 2>nul
    popd
) else (
    rem dossier lib introuvable — rien à faire
)

REM ============================================================
REM Création du WAR
REM ============================================================

echo -----------------------------
echo 📦 Création du WAR…
echo -----------------------------

cd "%BUILD_DIR%"
jar cf "%WAR_FILE%" *

echo -----------------------------
echo 🔍 Vérification du contenu WAR
echo -----------------------------
jar tf "%WAR_FILE%"

move "%WAR_FILE%" "..\" >nul
cd ..


REM ============================================================
REM Déploiement dans Tomcat
REM ============================================================

echo -----------------------------
echo 🚀 Déploiement sur Tomcat
echo -----------------------------

REM Supprimer l'ancien dossier déployé pour forcer le redeploiement
if exist "%TOMCAT_WEBAPPS%\%APP_NAME%" (
    rmdir /s /q "%TOMCAT_WEBAPPS%\%APP_NAME%"
)

move "%WAR_FILE%" "%TOMCAT_WEBAPPS%\" >nul

REM Correction : définir CATALINA_HOME avant lancement
set CATALINA_HOME=%TOMCAT_HOME%

REM Sauver et supprimer temporairement JAVA_TOOL_OPTIONS pour éviter l'avertissement CDS
set "OLD_JAVA_TOOL_OPTIONS=%JAVA_TOOL_OPTIONS%"
set "JAVA_TOOL_OPTIONS="

echo 🔄 Redémarrage de Tomcat…
call "%TOMCAT_HOME%\bin\shutdown.bat"
timeout /t 3 /nobreak >nul
call "%TOMCAT_HOME%\bin\startup.bat"

REM Restaurer JAVA_TOOL_OPTIONS
set "JAVA_TOOL_OPTIONS=%OLD_JAVA_TOOL_OPTIONS%"


echo.
echo ✅ Déploiement terminé !

endlocal