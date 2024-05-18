#!/data/data/com.termux/files/usr/bin/sh

start(){
clear
}



CHROOT=$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu

install_ubuntu(){
echo
if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
echo ${G}"Existing Ubuntu installation found, Resetting it..."${W}
proot-distro reset ubuntu
else
echo ${G}"Installing Ubuntu..."${W}
echo
pkg update
pkg install proot-distro
proot-distro install ubuntu
fi
}

install_desktop(){
echo ${G}"Installing XFCE Desktop..."${W}
cat > $CHROOT/root/.bashrc <<- EOF
apt-get update
apt install udisks2 git wget nano -y
rm -rf /var/lib/dpkg/info/udisks2.postinst
echo "" >> /var/lib/dpkg/info/udisks2.postinst
dpkg --configure -a
apt-mark hold udisks2
apt-get install xfce4 gnome-terminal nautilus dbus-x11 tigervnc-standalone-server -y
echo "vncserver -geometry 1280x720 -xstartup /usr/bin/startxfce4" >> /usr/local/bin/vncstart
echo "vncserver -kill :* ; rm -rf /tmp/.X1-lock ; rm -rf /tmp/.X11-unix/X1" >> /usr/local/bin/vncstop
chmod +x /usr/local/bin/vncstart 
chmod +x /usr/local/bin/vncstop 
sleep 2
exit
echo
EOF
proot-distro login ubuntu 
rm -rf $CHROOT/root/.bashrc
}

adding_user(){
echo ${G}"Adding a User..."${W}
cat > $CHROOT/root/.bashrc <<- EOF
apt-get update
apt-get install sudo wget -y
sleep 2
useradd -m -s /bin/bash charis
echo "charis:ch" | chpasswd
echo "charis ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/charis
sleep 2
exit
echo
EOF
proot-distro login ubuntu
echo "proot-distro login --user charis ubuntu" >> $PREFIX/bin/charis
chmod +x $PREFIX/bin/charis
rm $CHROOT/root/.bashrc
}

install_theme(){
echo ${G}"Installing Theme"${W}
mv $CHROOT/home/charis/.bashrc $CHROOT/home/charis/.bashrc.bak
echo "wget https://raw.githubusercontent.com/agcrisbp/LinuxAndroid/main/theme/theme.sh ; bash  theme.sh; exit" >> $CHROOT/home/charis/.bashrc
charis
rm $CHROOT/home/charis/theme.sh*
rm $CHROOT/home/charis/.bashrc
mv $CHROOT/home/charis/.bashrc.bak $CHROOT/home/charis/.bashrc
cp $CHROOT/home/charis/.bashrc $CHROOT/root/.bashrc
sed -i 's/32/31/g' $CHROOT/root/.bashrc
}

install_extra(){
echo ${G}"Installing Extra"${W}
cat > $CHROOT/root/.bashrc <<- EOF
echo "deb http://ftp.debian.org/debian stable main contrib non-free" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 605C66F00D6C9793
apt update
apt install firefox-esr gedit -y
exit
EOF
proot-distro login ubuntu
rm $CHROOT/root/.bashrc
}

sound_fix(){
echo ${G}"Fixing Sound..."${W}
pkg update
pkg install x11-repo -y ; pkg install pulseaudio -y
cat > $HOME/.bashrc <<- EOF
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
EOF

mv $CHROOT/home/charis/.bashrc $CHROOT/home/charis/.bashrc.bak
cat > $CHROOT/home/charis/.bashrc <<- EOF
vncstart
sleep 4
DISPLAY=:1 firefox &
sleep 10
pkill -f firefox
vncstop
sleep 4
exit
echo
EOF
charis
rm $CHROOT/home/charis/.bashrc
mv $CHROOT/home/charis/.bashrc.bak $CHROOT/home/charis/.bashrc
wget -O $(find $CHROOT/home/charis/.mozilla/firefox -name *.default-esr)/user.js https://raw.githubusercontent.com/agcrisbp/LinuxAndroid/main/fixes/user.js
}

end(){
echo
echo ${G}"Installion completed"
echo
echo "charis  -  To start Ubuntu"
echo
echo "ch  -  default charis password"
echo
echo "vncstart  -  To start vncserver, Execute inside charis"
echo
echo "vncstop  -  To stop vncserver, Execute inside charis"${W}
rm -rf ~/install.sh
}

start
install_ubuntu
install_desktop
install_extra
adding_user
install_theme
sound_fix
end
