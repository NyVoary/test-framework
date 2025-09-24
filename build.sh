#!/bin/bash
# Compile les servlets, crée le WAR et déploie dans Tomcat

APP_NAME="TestFramework"
TOMCAT_HOME="/opt/tomcat"
TOMCAT_WEBAPPS="$TOMCAT_HOME/webapps"
SRC_DIR="src/main/java"
WEB_DIR="src/main/webapps"
LIB_DIR="lib"
BUILD_DIR="build"
WAR_FILE="$APP_NAME.war"

# Nettoyage
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/WEB-INF/classes"

# Compilation
javac -cp "$LIB_DIR/servlet-api.jar:$LIB_DIR/Framework.jar" \
    -d "$BUILD_DIR/WEB-INF/classes" \
    $(find "$SRC_DIR" -name "*.java")

# Copier web.xml
cp "$WEB_DIR/WEB-INF/web.xml" "$BUILD_DIR/WEB-INF/"

# Copier pages statiques
cp "$WEB_DIR/index.html" "$BUILD_DIR/"
cp -r "$WEB_DIR/web" "$BUILD_DIR/" 2>/dev/null

# Copier libs dans le WAR
mkdir -p "$BUILD_DIR/WEB-INF/lib"
cp "$LIB_DIR"/*.jar "$BUILD_DIR/WEB-INF/lib/"

# Créer le WAR
jar cf "$WAR_FILE" -C "$BUILD_DIR" .

# Déployer
mv "$WAR_FILE" "$TOMCAT_WEBAPPS/"

# Redémarrer Tomcat
$TOMCAT_HOME/bin/shutdown.sh
sleep 3
$TOMCAT_HOME/bin/startup.sh

echo "✅ Déploiement terminé !"
echo "Index : http://localhost:8080/$APP_NAME/"
echo "Servlet : http://localhost:8080/$APP_NAME/hello"
