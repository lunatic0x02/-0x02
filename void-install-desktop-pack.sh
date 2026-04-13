#!/bin/bash

set -e
STARTING_DIR="$(pwd)"
THEME_NAME="milkyway"

# Installing Required Desktop Packages
echo "# Installing Required Desktop Packages"
sudo xbps-install -y git kvantum megatools python3-pipx
pipx install konsave
pipx ensurepath
if [ ! -d "${THEME_NAME}".desktop ]; then
    megadl --path ./ $(grep '^URL' "${THEME_NAME}".desktop | cut -d'=' -f2-)
fi
konsave -i "${THEME_NAME}".knsv
ln -s $HOME/-0x02/Scripts/ $HOME

# Setting Kvantum Theme ####
echo "# Setting Kvantum Theme"
kvantummanager --set "$(grep '^theme=' ~/.config/Kvantum/kvantum.kvconfig | sed 's/theme=//')"


# Building Better Blur ####
echo "# Building Better Blur"
mkdir -p ~/builds
cd ~/builds

sudo xbps-install -y base-devel extra-cmake-modules qt6-base-devel qt6-declarative-devel kwin-devel kf6-kcolorscheme-devel kf6-kconfig-devel kf6-kconfigwidgets-devel kf6-kcoreaddons-devel kf6-ki18n-devel kf6-kcmutils-devel kf6-kwidgetsaddons-devel kf6-kwindowsystem-devel kf6-kdecoration-devel

if [ ! -d "kwin-effects-better-blur-dx" ]; then
    git clone https://github.com/xarblu/kwin-effects-better-blur-dx
fi

cd kwin-effects-better-blur-dx

mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j"$(nproc)"
sudo make install


# Building Shader Wallpaper ####
cd ~/builds

git clone https://github.com/y4my4my4m/kde-shader-wallpaper.git
rm -rf ~/.local/share/plasma/wallpapers/online.knowmad.shaderwallpaper/
kpackagetool6 -t Plasma/Wallpaper -i kde-shader-wallpaper/package


# Finishing ####
echo "# Applying all configs"
konsave -a $THEME_NAME
echo "# Restarting Plasma Shell (Plasma 6)"
kquitapp6 plasmashell || true
plasmashell --replace &>/dev/null &

echo "# Installation Finished!"
echo "If the theme is not applied, try logging out and back in or rebooting."
