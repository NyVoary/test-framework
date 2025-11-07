@echo off
setlocal

REM Compile les servlets, crée le WAR et déploie dans Tomcat

set APP_NAME=TestFramework
set TOMCAT_HOME=C:\Program Files\Tomcat\apache-tomcat-11.0.13
set TOMCAT_WEBAPPS=%TOMCAT_HOME%\webapps
set SRC_DIR=src\main\java
set WEB_DIR=src\main\webapps
set LIB_DIR=lib
set BUILD_DIR=build
set WAR_FILE=%APP_NAME%.war

REM Nettoyage
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%\WEB-INF\classes"

REM Compilation
for /r "%SRC_DIR%" %%f in (*.java) do (
    javac -cp "%LIB_DIR%\servlet-api.jar;%LIB_DIR%\Framework.jar" ^
        -d "%BUILD_DIR%\WEB-INF\classes" ^
        -source 21 -target 21 ^
        "%%f"
)

REM Copier web.xml
if exist "%WEB_DIR%\WEB-INF\web.xml" (
    copy "%WEB_DIR%\WEB-INF\web.xml" "%BUILD_DIR%\WEB-INF\"
)

REM Copier pages statiques
if exist "%WEB_DIR%\index.html" (
    copy "%WEB_DIR%\index.html" "%BUILD_DIR%\"
)

REM Copier dossier web
if exist "%WEB_DIR%\web" (
    xcopy "%WEB_DIR%\web" "%BUILD_DIR%\web\" /E /I /Y
)

REM Copier libs dans le WAR
if not exist "%BUILD_DIR%\WEB-INF\lib" mkdir "%BUILD_DIR%\WEB-INF\lib"
if exist "%LIB_DIR%\*.jar" (
    copy "%LIB_DIR%\*.jar" "%BUILD_DIR%\WEB-INF\lib\"
)

REM Créer le WAR
cd "%BUILD_DIR%"
jar cf "%WAR_FILE%" *
move "%WAR_FILE%" "..\"
cd ..

REM Déployer
move "%WAR_FILE%" "%TOMCAT_WEBAPPS%\"

REM Redémarrer Tomcat
call "%TOMCAT_HOME%\bin\shutdown.bat"
timeout /t 3 /nobreak >nul
call "%TOMCAT_HOME%\bin\startup.bat"

echo ✅ Déploiement terminé !
echo Index : http://localhost:8080/%APP_NAME%/
echo Servlet : http://localhost:8080/%APP_NAME%/hello

endlocal