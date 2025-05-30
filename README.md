# Painel SGA - Instalação Automatizada no Raspberry Pi 4

Este script realiza a instalação completa e automatizada do Painel SGA com JavaFX em dispositivos **Raspberry Pi 4**, utilizando **Java 23**, **JavaFX 23.0.2**, **interface LXDE**, e configurações otimizadas para o sistema operacional **Debian Bookworm**.

---

## ⚙️ Funcionalidades

- 🚫 Desativa o Wayland e força a sessão X11 (necessário para JavaFX)
- 🔄 Atualiza o sistema para o Debian Bookworm
- 📦 Instala dependências gráficas (LXDE, LightDM, etc.)
- ☕ Instala o JDK 23 e JavaFX 23.0.2 (aarch64)
- 🖥️ Instala o Painel SGA e sua interface UI
- ⚙️ Configura Java como padrão no sistema
- 🔁 Adiciona o Painel à inicialização automática (autostart LXDE)
- 🧾 Gera o arquivo `painel.conf` com parâmetros padrão
- ✅ Valida a instalação e exibe status

---

## 📥 Instalação

Execute diretamente no terminal com permissões de root:

```bash
wget --inet4-only -O- https://raw.githubusercontent.com/CarloseOldenburg/Senha-Raspberry-PI4/refs/heads/main/senha-raspberry-pi4 | bash
````

---

## 📋 Requisitos

* Raspberry Pi 4 (64 bits)
* Sistema operacional baseado em **Debian Bullseye ou Bookworm**
* Acesso root (`sudo su`)
* Conexão com a internet (IPv4)

---

## 🔍 O que o script instala

| Componente        | Versão         | Fonte                                       |
| ----------------- | -------------- | ------------------------------------------- |
| JDK               | 23.0.2         | `painel-sga-cdn.s3.us-east-2.amazonaws.com` |
| JavaFX            | 23.0.2         | `painel-sga-cdn.s3.us-east-2.amazonaws.com` |
| Painel SGA        | 1.0-SNAPSHOT   | `painel-sga-cdn.s3.us-east-2.amazonaws.com` |
| UI (interface)    | -              | `painel-sga-cdn.s3.us-east-2.amazonaws.com` |
| Interface Gráfica | LXDE + LightDM | Instalados via `apt`                        |

---

## 📁 Estrutura de Arquivos

| Caminho                                | Descrição                                    |
| -------------------------------------- | -------------------------------------------- |
| `/home/pi/painel-sga-1.0-SNAPSHOT.jar` | Aplicação principal do Painel SGA            |
| `/home/pi/javafx-sdk-23.0.2/`          | SDK do JavaFX                                |
| `/home/pi/ui/`                         | Interface gráfica e imagens                  |
| `/home/pi/painel.conf`                 | Arquivo de configuração do Painel SGA        |
| `/home/pi/.config/autostart/`          | Atalho para iniciar o painel automaticamente |
| `/home/pi/painel.log`                  | Log de execução da aplicação                 |

---

## 📝 Configuração do painel.conf (exemplo)

```ini
CorSenha=#f2f2f2
ScreensaverUrl=file:/home/pi/media/img/SSBack.png
IPServidor=http://IP
Servicos=1,2,3,4,6,7,...
Language=pt
MainLayout=1
CorMensagem=#ffffff
UnidadeId=1
VideoID=1
ScreensaverLayout=3
Vocalizar=true
Som=alert.wav
CorFundo=#33cc99
CorGuiche=#ffffff
ScreensaverTimeout=30
```

---

## 🧪 Validação final

Ao fim da instalação, o script verifica:

* Presença do JAR principal
* Disponibilidade do Java
* Existência do `painel.conf`

Você verá:

```bash
✅ Instalação concluída com sucesso!
📍 Verifique o log em /home/pi/painel.log após reiniciar.
📂 painel.conf em /home/pi/
🖼️ Imagem de fundo em /home/pi/ui/img/
🔁 Reinicie agora com 'sudo reboot'
```

---

## 📌 Observações

* Após reiniciar, o painel será iniciado automaticamente via `lxterminal`.
* O modo gráfico é iniciado pelo **LightDM com sessão LXDE**.
* É possível editar `painel.conf` manualmente para personalizar a experiência.

---

## 👤 Autor

Desenvolvido por [Carlos Eduardo Oldenburg](https://github.com/CarloseOldenburg)
Hospedagem de arquivos via Amazon S3

---

## 📜 Licença

Distribuído sob licença livre para uso interno corporativo e manutenção de terminais com sistemas VideoSoft.
