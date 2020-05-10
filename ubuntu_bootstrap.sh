#!/usr/bin/bash

apt_install() {
	if hash $1 2>/dev/null; then
		echo "$1 is already installed"
	else
		sudo apt-get install $1
	fi
}

snap_install() {
	if hash $1 2>/dev/null; then
		echo "$1 is already installed"
	else
		sudo snap install $1
	fi
}

echo "=============================== INSTALLATION PHASE ==============================="

echo "Installing curl"
apt_install curl

# Install various compilers and toolchains
echo "Installing C compiler"
apt_intall gcc

echo "Installing C++ compiler"
apt_install g++

echo "Installing Java compiler and runtime" 
apt_install default-jdk

echo "Installing Rust compiler and toolchain"
if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust compiler and toolchain

    echo "Installing exa"
	$HOME/.cargo/bin/cargo install exa

    echo "Installing ripgrep"
	$HOME/.cargo/bin/cargo install ripgrep

    echo "Installing alacritty"
	sudo add-apt-repository ppa:mmstick76/alacritty
	apt_install alacritty

    echo "Installing RLS"
    $HOME/.cargo/rustup component add rls
fi

# Essentials
echo "Installing Make"
apt_install make

echo "Installing CMake"
apt_install cmake

echo "Installing vim"
apt_install vim

echo "Installing git"
apt_install git

echo "Installing VS Code"
if hash code 2>/dev/null; then
	echo "VS Code is already installed"
else
	sudo snap install --classic code
fi

echo "Installing htop"
apt_install htop

echo "Installing zsh"
apt_install zsh

echo "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # oh-my-zsh
fi

# Various frequently used applications (it assumes that snap exists)
echo "Installing VLC"
snap_install vlc

echo "Installing gimp"
apt_intall gimp

echo "Installing Spotify"
snap_install spotify

echo "=============================== SETUP PHASE ==============================="

echo "Setting up alacritty"
mkdir -p $HOME/.config/alacritty
wget https://raw.githubusercontent.com/aaron-williamson/base16-alacritty/master/colors/base16-atelier-dune.yml
cat base16-atelier-dune.yml > $HOME/.config/alacritty/alacritty.yml
rm base16-atelier-dune.yml

echo "Setting up zsh"
chsh gliontos /usr/bin/zsh
wget -O _zshrc https://raw.githubusercontent.com/GeorgeLS/Ubuntu-Bootstrap/master/.zshrc
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
mv _zshrc $HOME/.zshrc
