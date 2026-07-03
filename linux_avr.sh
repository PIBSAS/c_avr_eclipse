#!/bin/bash
# setup_avr.sh - Instala toolchain AVR, avrdude, VS Code, y configura el PATH

set -e  # Detiene el script ante cualquier error

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

echo -e "${GREEN}==> Actualizando repositorios...${NC}"
sudo apt update

echo -e "${GREEN}==> Instalando paquetes requeridos: build-essential, avrdude${NC}"
sudo apt install -y build-essential avrdude

echo -e "${GREEN}==> Instalando VS Code (code)...${NC}"
echo "   > Instalando dependencias para el repositorio de Microsoft..."
sudo apt install -y gpg
sudo install -d -m 0755 /etc/apt/keyrings
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg > /dev/null
sudo chmod 0644 /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
echo "   > Actualizando repositorios con el nuevo origen..."
sudo apt update
echo "   > Instalando code..."
sudo apt install -y code

echo -e "${GREEN}==> Descargando toolchain AVR desde Microchip...${NC}"
wget "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/avr8-gnu-toolchain-4.0.0.52-linux.any.x86_64.tar.gz" -O avr-toolchain.tar.gz

echo -e "${GREEN}==> Extrayendo archivo...${NC}"
tar -xzf avr-toolchain.tar.gz

# La carpeta extraída se llama avr8-gnu-toolchain-linux_x86_64
if [ -d "avr-toolchain" ]; then
    echo -e "${YELLOW}La carpeta avr-toolchain ya existe. Eliminando para actualizar...${NC}"
    rm -rf avr-toolchain
fi

mv avr8-gnu-toolchain-linux_x86_64 avr-toolchain

echo -e "${GREEN}==> Agregando el toolchain al PATH en ~/.bashrc...${NC}"
grep -qxF 'export PATH="$HOME/avr-toolchain/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/avr-toolchain/bin:$PATH"' >> ~/.bashrc

echo -e "${GREEN}==> Recargando .bashrc en esta terminal (solo para el script)...${NC}"
source ~/.bashrc

echo -e "${GREEN}¡Instalación completada exitosamente!${NC}"
echo ""
echo "El PATH ha sido actualizado para esta sesión."
echo "Para usar los comandos en nuevas terminales, ya quedará configurado automáticamente."
echo "Puedes probar con: avr-gcc --version"
echo "O flashear con: avrdude -c ... (según tu programador)"
echo "VS Code ya está instalado, puedes ejecutarlo con: code"
