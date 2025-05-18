#!/bin/bash
# Instalação automatizada do Painel SGA no Raspberry Pi 4
# sudo wget --inet4-only -O- https://raw.githubusercontent.com/CarloseOldenburg/senhapi4/main/senhpi4.sh | bash

# === CONFIGURAÇÃO ===
JDK_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/jdk-23_linux-aarch64_bin.tar.gz"
JAVAFX_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/openjfx-23.0.2_linux-aarch64_bin-sdk.zip"
PAINEL_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/painel-sga.zip"
USER_HOME="/home/pi"

echo "📦 Atualizando fontes para Bookworm..."
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list

echo "📦 Atualizando o sistema..."
sudo apt update && sudo apt full-upgrade -y

echo "📦 Instalando bibliotecas necessárias..."
sudo apt install -y libgtk-3-dev libgl1-mesa-glx unzip wget lxterminal

echo "📥 Baixando e extraindo JDK..."
wget -O /tmp/jdk.tar.gz "$JDK_URL"
sudo tar -xzf /tmp/jdk.tar.gz -C /opt
sudo rm /tmp/jdk.tar.gz

echo "📥 Baixando e extraindo JavaFX..."
wget -O /tmp/javafx.zip "$JAVAFX_URL"
unzip -q /tmp/javafx.zip -d "$USER_HOME"
rm /tmp/javafx.zip

echo "📥 Baixando e extraindo Painel SGA..."
wget -O /tmp/painel-sga.zip "$PAINEL_URL"
unzip -q /tmp/painel-sga.zip -d "$USER_HOME"
rm /tmp/painel-sga.zip

echo "⚙️  Configurando o JDK 23 como padrão..."
sudo update-alternatives --install /usr/bin/java java /opt/jdk-23.0.2/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk-23.0.2/bin/javac 1

echo "🚀 Criando atalho de inicialização automática..."
AUTOSTART_DIR="$USER_HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/painel-sga.desktop"

mkdir -p "$AUTOSTART_DIR"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Name=Painel SGA
Comment=Iniciar automaticamente o painel de senhas
Exec=lxterminal -e java -Djava.library.path=$USER_HOME/javafx-sdk-23.0.2/lib --module-path $USER_HOME/javafx-sdk-23.0.2/lib --add-modules javafx.controls,javafx.fxml,javafx.web,javafx.swing,javafx.media -jar $USER_HOME/painel-sga-1.0-SNAPSHOT.jar
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chmod +x "$DESKTOP_FILE"
chmod +x "$USER_HOME/painel-sga-1.0-SNAPSHOT.jar"

echo "✅ Instalação finalizada com sucesso!"
echo "🔁 Reinicie o Raspberry Pi para iniciar o painel automaticamente."
