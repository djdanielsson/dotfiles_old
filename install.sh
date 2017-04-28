#! /bin/bash
#http://kumarcode.com/Colorful-i3/
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
path=pwd

if [ "$(awk 'NR==1{print $1}' /etc/*release)" == "Fedora" ]; then
  OS=fedora
  echo -e "${BLUE}you are running $OS${NC}"
elif [ "$(awk 'NR==1{print $1}' /etc/*release)" == "Antergos" ]; then
  OS=arch
  echo -e "${BLUE}you are running $OS${NC}"
elif [ $(awk 'NR==1{print $1}' /etc/*release | cut -d '"' -f2) == "Debian" ]; then
  OS=debian
  echo -e "${BLUE}you are running $OS${NC}"
elif [ "$(cat /etc/issue | cut -f 1 -d ' ')" == "Ubuntu" ]; then
  OS=ubuntu
  echo -e "${BLUE}you are running $OS${NC}"
elif [ "$(awk 'NR==1{print $1}' /etc/*release)" == "CentOS" ]; then
  OS=centos
  echo -e "${BLUE}you are running $OS${NC}"
else
  echo -e "${RED}couldn't figure out what OS you are running${NC}"
  exit 1
fi

#if [ "$(whoami)" == "root" ]; then
#  echo "do not run as root"
#  exit 1
#fi

echo -e "${BLUE}base applications install${NC}"
case $OS in
  fedora)
    su -c 'dnf remove -y vim-minimal'
    su -c 'dnf install -y vim git sudo'
    ;;
  arch)
    su -c 'pacman -S --noconfirm vim git'
    ;;
  debian)
    su -c 'apt-get install -y vim git'
    ;;
  ubuntu)
    su -c 'apt-get install -y vim git'
    ;;
  centos)
    su -c 'yum install -y vim git'
    ;;
esac

echo -e "${BLUE}setting up workspace${NC}"
if ! [ -d ~/workspace ]; then
  mkdir -p ~/workspace
fi
if ! [ -d ~/workspace/dotfiles ]; then
  git clone https://github.com/djdanielsson/dotfiles.git ~/workspace/dotfiles
fi

echo -e "${BLUE}setting fonts for vim${NC}"
if ! [ -d ~/.local/share/ ]; then
  mkdir -p ~/.local/share/
  if ! [ -d ~/.local/share/fonts ]; then
    cp -r ~/workspace/dotfiles/fonts/ ~/.local/share/
    su -c 'fc-cache -fv'
  fi
fi

echo -e "${BLUE}adding other repositories and installing applications${NC}"
if [ $OS == fedora ]; then
  su -c 'dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm dnf-plugins-core'
  su -c 'dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo'
  su -c 'dnf config-manager --add-repo https://copr.fedorainfracloud.org/coprs/yaroslav/i3desktop/repo/fedora-$(rpm -E %fedora)/yaroslav-i3desktop-fedora-$(rpm -E %fedora).repo'
  su -c 'dnf config-manager --add-repo https://copr.fedorainfracloud.org/coprs/pkajaba/i3blocks/repo/fedora-24/pkajaba-i3blocks-fedora-24.repo'
  su -c 'dnf config-manager --enable docker-ce-edge'
  su -c 'dnf config-manager --enable yaroslav/i3desktop-fedora-$(rpm -E %fedora)'
  su -c 'dnf config-manager --enable pkajaba/i3blocks-fedora-24'
  su -c 'dnf clean all'
  su -c 'dnf install -y i3blocks acpi i3lock xautolock rofi emacs ruby python firefox gnome-terminal powertop docker-ce xbacklight'
fi

echo -e "${BLUE}setting up vim and addons${NC}"
if ! [ -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

echo -e "${BLUE}setting configuration files${NC}"
if ! [ -e ~/.i3 ]; then
  mkdir -p ~/.i3
fi
if ! [ -h ~/.vimrc ]; then
  rm ~/.vimrc 2> /dev/null
  ln -s ~/workspace/dotfiles/.vimrc ~/
fi
if ! [ -h ~/.bashrc ]; then
  rm ~/.bashrc 2> /dev/null
  ln -s ~/workspace/dotfiles/.bashrc ~/
fi
if ! [ -h ~/.i3/config ]; then
  if [ $OS == "arch" ]; then
    rm ~/.i3/config 2> /dev/null
    ln -s ~/workspace/dotfiles/config-arch ~/.i3/config
  else
    rm ~/.i3/config 2> /dev/null
    ln -s ~/workspace/dotfiles/config ~/.i3/
  fi
fi
if ! [ -h ~/.i3/IconicWeather.sh ]; then
  rm ~/.i3/IconicWeather.sh 2> /dev/null
  ln -s ~/workspace/dotfiles/IconicWeather.sh ~/.i3/
fi
if ! [ -h ~/.i3/i3blocks.conf ]; then
  if [ $OS == "arch" ]; then
    rm ~/.i3/i3blocks.conf 2> /dev/null
    ln -s ~/workspace/dotfiles/i3blocks.conf-arch ~/.i3/i3blocks.conf
  else
    rm ~/.i3/i3blocks.conf 2> /dev/null
    ln -s ~/workspace/dotfiles/i3blocks.conf ~/.i3/
  fi
fi
if ! [ -h ~/.i3/lock.png ]; then
  rm ~/.i3/lock.png 2> /dev/null
  ln -s ~/workspace/dotfiles/lock.png ~/.i3/
fi
if ! [ -d ~/.config/dconf/ ]; then
  mkdir -p ~/.config/dconf/
fi
if ! [ -h ~/.config/dconf/user ]; then
  rm ~/.config/dconf/user 2> /dev/null
  ln -s ~/workspace/dotfiles/user ~/.config/dconf/
fi

#echo "adding docker so it can be used without sudo"
#sudo groupadd docker
#sudo gpasswd -a ${USER} docker
echo -e "${BLUE}base install complete${NC}"


