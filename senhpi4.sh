#!/bin/bash
# Instalação automatizada do Painel SGA no Raspberry Pi 4
# sudo wget --inet4-only -O- https://raw.githubusercontent.com/CarloseOldenburg/senhapi4/main/senhpi4.sh | bash

# === CONFIGURAÇÃO ===
JDK_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/jdk-23_linux-aarch64_bin.tar.gz"
JAVAFX_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/openjfx-23.0.2_linux-aarch64_bin-sdk.zip"
PAINEL_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/painel-sga.zip"
USER_HOME="/home/pi"
CONFIG_FILE="$USER_HOME/arquivo.conf"

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
sudo rm -rf "$USER_HOME/javafx-sdk-23.0.2"
unzip -o -q /tmp/javafx.zip -d "$USER_HOME"
sudo chown -R pi:pi "$USER_HOME/javafx-sdk-23.0.2"
rm /tmp/javafx.zip

echo "📥 Baixando e extraindo Painel SGA..."
wget -O /tmp/painel-sga.zip "$PAINEL_URL"
unzip -uo -q /tmp/painel-sga.zip -d "$USER_HOME"
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

echo "📝 Criando ou substituindo o arquivo de configuração..."

# Remove se existir
[ -f "$CONFIG_FILE" ] && rm "$CONFIG_FILE"

# Cria o novo arquivo
cat <<EOF > "$CONFIG_FILE"
#Novo SGA configuration file
#Tue Sep 16 10:23:59 BRT 2014
CorSenha=\#f2f2f2
ScreensaverUrl=file\:/home/pi/media/img/SSBack.png
IPServidor=http://192.168.10.182
Servicos=1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
Language=pt
MainLayout=1
CorMensagem=\#ffffff
UnidadeId=1
VideoID=1
ScreensaverLayout=3
Vocalizar=true
Som=alert.wav
CorFundo=\#33cc99
CorGuiche=\#ffffff
ScreensaverTimeout=30
EOF

chmod 644 "$CONFIG_FILE"

echo "✅ Instalação finalizada com sucesso!"
echo "🔁 Reinicie o Raspberry Pi para iniciar o painel automaticamente."
