#!/bin/bash
sudo dnf install \
ninja-build \
cmake \
meson \
gcc-c++ \
libxcb-devel \
libX11-devel \
pixman-devel \
cairo-devel \
pango-devel \
libdrm-devel \
libudev-devel \
libdisplay-info-devel \
pixman-devel \
libseat-devel \
hwdata-devel \
libdisplay-info-devel \
libliftoff-devel \
vulkan-loader-devel \
glslang-devel \
libinput-devel \
xorg-x11-server-Xwayland-devel \
xcb-util-renderutil-devel \
'pkgconfig(xcb-ewmh)' \
'pkgconfig(gbm)' \
'pkgconfig(xkbcommon)' \
'pkgconfig(egl)' \
'pkgconfig(wayland-server)'
wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.32/downloads/wayland-protocols-1.32.tar.xz
tar xf wayland-protocols-1.32.tar.xz
cd wayland-protocols-1.32 &&
mkdir build &&
cd    build &&
meson setup --prefix=/usr --buildtype=release &&
ninja
sudo ninja install
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
meson --buildtype=release _build  
ninja -C _build
sudo ninja -C _build install
mkdir ~/.config/hypr/
curl -s https://raw.githubusercontent.com/MiguelCarino/Carino-Systems/main/profiles/hyprland.conf > ~/.config/hypr/hyprland.conf