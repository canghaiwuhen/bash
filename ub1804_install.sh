#!/bin/bash
(
cat <<EOF
deb http://mirrors.ustc.edu.cn/ubuntu bionic main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu bionic-security main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu bionic-updates main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu bionic-proposed main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu bionic-backports main restricted universe multiverse

deb-src http://mirrors.ustc.edu.cn/ubuntu bionic main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu bionic-security main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu bionic-updates main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu bionic-proposed main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu bionic-backports main restricted universe multiverse
EOF
) > /etc/apt/sources.list

apt-get update && apt-get upgrade && apt-get -u dist-upgrade

apt-get install zsh vim openssh-server console-setup rar unrar ntpdate unzip htop screen tmux psmisc bzip2 nload wireless-tools wpasupplicant linux-headers-`uname -r` build-essential kernel-package autoconf lzma bc subversion git libncurses5-dev 

sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
echo "greeter-show-manual-login=true" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf

service ssh restart

echo "*/30 *  * * *   /usr/sbin/ntpdate cn.pool.ntp.org" > /etc/cron.d/ntp
crontab /etc/cron.d/ntp
/etc/init.d/cron restart

update-alternatives --config editor

dpkg-reconfigure console-setup

/etc/init.d/console-setup start

sysv-rc-conf

vi /etc/network/interfaces 

echo >> /etc/motd

(
cat <<EOF
# ~/.bashrc: executed by bash(1) for non-login shells.

#PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '
PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\\$ ' 
umask 022

# You may uncomment the following lines if you want 'ls' to be colorized:
export LS_OPTIONS='--color=auto'
#eval "\`dircolors\`"
alias ls='ls \$LS_OPTIONS'
alias ll='ls \$LS_OPTIONS -l'
alias l='ls \$LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

if [ -f /etc/bash_completion ];then
        . /etc/bash_completion
fi
EOF
) > /root/.bash_profile

vi /etc/hosts 
vi /etc/hostname
vi /etc/fstab 

rm -rf /etc/grub.d/20_memtest86+
sed -i "s/GRUB_TIMEOUT=10/GRUB_TIMEOUT=3/g" /etc/default/grub
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/g" /etc/default/grub
sed -i "s/#GRUB_DISABLE/GRUB_DISABLE/g" /etc/default/grub


update-grub2

sed -i "s/timeout=-1/timeout=3/g" /boot/grub/grub.cfg

sed -i "s/^printf/#printf/g" /etc/update-motd.d/10-help-text

echo "Over!"


