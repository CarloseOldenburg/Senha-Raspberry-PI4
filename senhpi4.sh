#!/bin/bash
# Instalação automatica do Painel SGA no Raspberry Pi 4
# sudo wget --inet4-only -O- https://raw.githubusercontent.com/CarloseOldenburg/senhapi4/main/senhpi4.sh | bash

# === VERIFICAÇÃO DE ROOT ===
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script deve ser executado como root (sudo su)."
  exit 1
fi

# === CONFIGURAÇÃO ===
JDK_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/jdk-23_linux-aarch64_bin.tar.gz"
JAVAFX_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/openjfx-23.0.2_linux-aarch64_bin-sdk.zip"
PAINEL_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/painel-sga.zip"
UI_URL="https://painel-sga-cdn.s3.us-east-2.amazonaws.com/ui.zip"
USER_HOME="/home/pi"
CONFIG_FILE="$USER_HOME/painel.conf"
JAR_FILE="$USER_HOME/painel-sga-1.0-SNAPSHOT.jar"

echo "Atualizando fontes para Bookworm..."
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list

echo "Atualizando o sistema..."
apt update && apt full-upgrade -y

echo "Instalando bibliotecas necessárias..."
apt install -y libgtk-3-dev libgl1-mesa-glx unzip wget lxterminal

echo "Baixando e extraindo JDK..."
wget -O /tmp/jdk.tar.gz "$JDK_URL"
tar -xzf /tmp/jdk.tar.gz -C /opt
rm /tmp/jdk.tar.gz

echo "Baixando e extraindo JavaFX..."
wget -O /tmp/javafx.zip "$JAVAFX_URL"
rm -rf "$USER_HOME/javafx-sdk-23.0.2"
unzip -o -q /tmp/javafx.zip -d "$USER_HOME"
chown -R pi:pi "$USER_HOME/javafx-sdk-23.0.2"
rm /tmp/javafx.zip

echo "Baixando e extraindo Painel SGA..."
wget -O /tmp/painel-sga.zip "$PAINEL_URL"
unzip -uo -q /tmp/painel-sga.zip -d "$USER_HOME"
rm /tmp/painel-sga.zip

echo "Baixando e extraindo UI..."
wget -O /tmp/ui.zip "$UI_URL"
unzip -uo -q /tmp/ui.zip -d "$USER_HOME"
rm /tmp/ui.zip

echo "⚙Configurando o JDK 23 como padrão..."
update-alternatives --install /usr/bin/java java /opt/jdk-23.0.2/bin/java 1
update-alternatives --install /usr/bin/javac javac /opt/jdk-23.0.2/bin/javac 1

echo "Criando atalho de inicialização automática..."
AUTOSTART_DIR="$USER_HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/painel-sga.desktop"

mkdir -p "$AUTOSTART_DIR"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Name=Painel SGA
Comment=Iniciar automaticamente o painel de senhas
Exec=lxterminal -e java -Djava.library.path=$USER_HOME/javafx-sdk-23.0.2/lib --module-path $USER_HOME/javafx-sdk-23.0.2/lib --add-modules javafx.controls,javafx.fxml,javafx.web,javafx.swing,javafx.media -jar $JAR_FILE
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chmod +x "$DESKTOP_FILE"
chmod +x "$JAR_FILE"

echo "Criando ou substituindo o arquivo de configuração..."
[ -f "$CONFIG_FILE" ] && rm "$CONFIG_FILE"

cat <<EOF > "$CONFIG_FILE"
#Novo SGA configuration file
#$(date)
CorSenha=\#f2f2f2
ScreensaverUrl=file\:/home/pi/media/img/SSBack.png
IPServidor=http://IP
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
chown pi:pi "$CONFIG_FILE"

echo "Validando instalação..."

# Verificações
success=true

if [ ! -f "$JAR_FILE" ]; then
  echo "ERRO: Arquivo $JAR_FILE não encontrado!"
  success=false
else
  echo "JAR encontrado: $JAR_FILE"
fi

if ! command -v java >/dev/null 2>&1; then
  echo "ERRO: Java não está disponível no sistema!"
  success=false
else
  echo "Java disponível: $(java -version 2>&1 | head -n1)"
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERRO: Arquivo de configuração $CONFIG_FILE não foi criado!"
  success=false
else
  echo "Arquivo de configuração criado: $CONFIG_FILE"
fi

if $success; then
  echo "Tudo certo! Instalação concluída com sucesso!"
else
  echo "A instalação terminou com problemas. Verifique as mensagens acima."
fi

echo "Reinicie o Raspberry Pi para iniciar o painel automaticamente."
