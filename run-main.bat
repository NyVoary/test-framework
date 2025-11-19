@echo off
setlocal enabledelayedexpansion

echo ==============================================
echo  BUILD + RUN TestAnnotation (annotation demo)
echo ==============================================
echo.

REM Aller à la racine du repo
cd /d "%~dp0"

REM ============================================================
REM 1) Compiler TestAnnotation
REM ============================================================

echo [1/2] Compilation de TestAnnotation...

javac -d build/classes ^
  -cp "lib\Framework.jar" ^
  src\main\java\test\annotation\TestAnnotation.java

IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Echec compilation TestAnnotation
    exit /b 1
)

echo ✓ Compilation OK : build/classes/test/annotation/*.class


REM ============================================================
REM 3) Lancer TestAnnotation
REM ============================================================

echo [2/2] Execution de test.annotation.TestAnnotation ...
echo ----------------------------------------

java -cp "build/classes;lib\Framework.jar" test.annotation.TestAnnotation
set RUN_RC=%ERRORLEVEL%
echo ----------------------------------------

IF %RUN_RC% NEQ 0 (
  echo ERREUR: L'execution de TestAnnotation a echoue (code %RUN_RC%)
  exit /b %RUN_RC%
)

echo.
echo ✓ Terminé !