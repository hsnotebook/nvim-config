#!/bin/env bash

JDTLS_HOME=/home/hs/.config/jdtls
JDTLS_SERVER=$JDTLS_HOME/server

JAR="$JDTLS_SERVER/plugins/org.eclipse.equinox.launcher_*.jar"
GRADLE_HOME=$HOME/gradle /usr/lib/jvm/java-11-openjdk/bin/java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -javaagent:/home/hs/.config/nvim/java/lombok.jar \
  -jar $(echo "$JAR") \
  -configuration "$JDTLS_SERVER/config_linux" \
  -data "${1:-$JDTLS_HOME/workspace}" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED
