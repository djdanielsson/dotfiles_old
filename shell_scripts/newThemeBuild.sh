#!/bin/bash
#script to install https://github.com/unix121/i3wm-themer
sudo dnf install i3-gaps rofi python3 nitrogen npm

#curl -k https://gist.githubusercontent.com/nirix/d412167f3fbbff1ae141fe9f24d85a45/raw/304fbff14d5bfc8c89dcf53f598df51d1ea2d3eb/install-polybar.sh | bash
#curl -k https://gist.githubusercontent.com/nirix/d412167f3fbbff1ae141fe9f24d85a45/raw/304fbff14d5bfc8c89dcf53f598df51d1ea2d3eb/install-polybar-ex.sh | bash
#next 10 lines are copied from link above
sudo dnf install -y cmake @development-tools gcc-c++ i3-ipc jsoncpp-devel alsa-lib-devel pulseaudio-libs-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel xcb-util-xrm xcb-util-xrm-devel

rm -rf /tmp/polybar
git clone --recursive https://github.com/jaagr/polybar /tmp/polybar
cd /tmp/polybar || exit

pkill polybar

./build.sh -f


sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
mkdir fonts
cd fonts || exit
wget https://use.fontawesome.com/releases/v5.0.13/fontawesome-free-5.0.13.zip
unzip fontawesome-free-5.0.13.zip
cd fontawesome-free-5.0.13 || exit
sudo cp use-on-desktop/* /usr/share/fonts
sudo fc-cache -f -v
cd ../.. || exit
rm -fr fonts

git clone https://github.com/ryanoasis/nerd-fonts /tmp/
cd /tmp/nerd-fonts || exit
./install.sh
cd .. || exit
rm -rf nerd-fonts

#npm install git://github.com/adobe-fonts/source-code-pro.git#release
npm install git://github.com/adobe-fonts/source-code-pro.git

git clone https://github.com/unix121/i3wm-themer.git /tmp/
cd /tmp/i3wm-themer || exit
pip install -r requirements.txt

cp -r scripts/* /home/$USER/.config/polybar/
cd src/ || exit
python i3wm-themer.py --config config.yaml --install defaults/
python i3wm-themer.py --config config.yaml --load themes/013.json


