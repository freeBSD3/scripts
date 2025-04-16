#!/usr/bin/perl

use strict;
use warnings;


my $parent_dir = '/home/jbm/tmp';
if (not -d $parent_dir)
{
  mkdir $parent_dir or die "Failed to create $parent_dir\n";  
}


my $xinitrc;
if (not -f "$parent_dir/.xinitrc")
{
  open($xinitrc, '>', "$parent_dir/.xinitrc")
    or die "Could not open file: $!";
  print $xinitrc <<'EOF';
exec /usr/local/bin/startfluxbox 
EOF
  close($xinitrc);
  undef $xinitrc;
}


my $vimrc;
if (not -f "$parent_dir/.vimrc")
{
  open($vimrc, '>', "$parent_dir/.vimrc")
    or die "Could not open file: $!";
  print $vimrc <<'EOF';
set expandtab
set nocompatible
set number
set shiftwidth=2
set tabstop=2
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set nohlsearch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
EOF
  close($vimrc);
  undef $vimrc;
}


my $Xresources;
if (not -f "$parent_dir/.Xresources")
{
  open($Xresources, '>', "$parent_dir/.Xresources")
    or die "Could not open file: $!";

  print $Xresources <<'EOF';
! Use a nice truetype font and size by default... 
! *.font: xft.Hack:size=12
! xterm*faceName: Hack Bold
xterm*faceName: Hack
xterm*faceSize: 12

! xterm enabled to handle clipboard events
xterm*selectToClipboard: true

! Every shell is a login shell by default (for inclusion of all necessary environment variables)
xterm*loginshell: true

! I like a LOT of scrollback...
xterm*savelines: 16384

! double-click to select whole URLs :D
xterm*charClass: 33:48,36-47:48,58-59:48,61:48,63-64:48,95:48,126:48

! DOS-box colours...
! Bright Green
xterm*foreground: rgb:00/ff/00

! Vibrant Orange
! xterm*foreground: rgb:ff/a5/00

! Black
xterm*background: rgb:00/00/00

xterm*color0: rgb:00/00/00
xterm*color1: rgb:a8/00/00
xterm*color2: rgb:00/a8/00
xterm*color3: rgb:a8/54/00
xterm*color4: rgb:00/00/a8
xterm*color5: rgb:a8/00/a8
xterm*color6: rgb:00/a8/a8
xterm*color7: rgb:a8/a8/a8
xterm*color8: rgb:54/54/54
xterm*color9: rgb:fc/54/54
xterm*color10: rgb:54/fc/54
xterm*color11: rgb:fc/fc/54
xterm*color12: rgb:54/54/fc
xterm*color13: rgb:fc/54/fc
xterm*color14: rgb:54/fc/fc
xterm*color15: rgb:fc/fc/fc

! right hand side scrollbar...
xterm*rightScrollBar: false 
xterm*ScrollBar: false

! stop output to terminal from jumping down to bottom of scroll again
xterm*scrollTtyOutput: false
EOF
  close($Xresources);
  undef $Xresources;
}


my $kshrc;
if (not -f "$parent_dir/.kshrc")
{
  open($kshrc, '>', "$parent_dir/.kshrc")
    or die "Could not open file: $!";

  print $kshrc <<'EOF';
# PS1=' ${PWD}  -->> '
PS1=' -->> '

# without this, arrow keys
# and tab completion were bugged
set -o emacs

alias krc='vim ~/.kshrc'
alias src='. ~/.kshrc'

alias ll='ls -l'
alias la='ls -a'
alias ldot='ls .*'

alias c=clear
alias cl=clear

alias install='yes | doas pkg install'
alias update='yes | doas pkg update'
alias search='pkg search'
alias vi=vim
alias dvim='doas vim'
alias reboot='doas reboot'
alias restart='doas reboot'
alias off='doas poweroff'
alias b='acpiconf -i 0 | grep Remain'
alias batt='acpiconf -i 0 | grep Remain'
alias ifc=ifconfig
alias ifup='doas ifconfig wlan0 up'
alias ifdown='doas ifconfig wlan0 down'

alias l='ls -cpv --color=auto'
alias ls='ls -cpv --color=auto'
alias sl='ls -cp --color=auto'
alias la='ls -acp --color=auto'

# alias install='yes | sudo dnf install'
# alias search='dnf search'

alias fast=fastfetch
alias ff='firefox >/dev/null 2>/dev/null &'
alias wiscan='ifconfig wlan0 scan'
alias tasks='vim ~/Documents/tasks.txt'
alias m=mplayer
alias menu='sudo vi /boot/grub/grub.cfg'
alias lo='libreoffice >/dev/null 2>/dev/null &'
alias poweroff='sudo poweroff'
alias mount='doas mount'
alias umount='doas umount'
alias du='du -hs'
alias py=python
alias ldev='ls /dev/ | grep da'
alias lynx='lynx -vikeys'
alias x0='xbacklight -dec 100'
alias phys='epdfview /home/jbm/classes/physics/physics*every*pdf*'
alias keys='vi /home/jbm/.fluxbox/keys'
alias df='df -h | grep home'
alias ping='ping -c 3 ddg.gg'
alias free='free -h'
alias lock=slock
alias mulcon='mullvad connect'
alias grep='grep -i'
alias path='echo -e ${PATH//:/"\n"} | lolcat'
alias areacode='cat ~/Documents/areacodes.txt | grep'
alias more=less
alias rmd='rm -r'
alias vlc='vlc --rate'
alias wthr='perl ~/scripts/wthr.pl'
alias newhop='perl ~/perl/relays.pl; sleep 5; ipaddr'

# :xdigit: for hexidecimal characters
alias macgrep="grep -Eo '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'"
alias ipgrep="grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'"

tidyperl()
{
  perltidy -gnu -i=2 $1
  mv $1.tdy $1
}

ipaddr()
{
  curl -s -o ipaddr -A "Windows NT" https://www.showmyip.com
  grep -E '>City|>Country|>Your IPv4|>Internet' ipaddr |\
  sed 's/<td>//g;s/<\/td>/ /g;s/<b>//g;s/<\/b>//g' |\
  lolcat -g 00FFFF:80FF00 -b
  # removes whitespace
  # sed 's/<td>//g;s/<\/td>/ /g;s/<b>//g;s/<\/b>//g' |\
  # sed 's/^[ \t]*//' | lolcat
  rm ipaddr
}

depsort()
{
	cat ~/Documents/to_install.txt | sort > ~/.dependency
	cat ~/.dependency > ~/Documents/to_install.txt
}

fynd()
{
  /usr/bin/find / -iname *$1* 2>/dev/null
}

wicon()
{
  doas ifconfig wlan0 ssid $1 up
  doas dhclient wlan0
}

docs()
{
	cd ~/Documents
}

scripts()
{
	cd ~/scripts
}

pics()
{
	cd ~/Pictures
}

stor()
{
	cd ~/Storage
}

downloads()
{
	cd ~/downloads
}

media()
{
        cd /media/
}

EOF
  close($kshrc);
  undef $kshrc;
}


my @dirs = (
  'books',
  'dotfiles',
  'Downloads',
  'Documents',
  'perl',
  'phone',
  'scripts',
  'Storage',
  'tablet',
  'writing',
);

foreach my $dir (@dirs)
{
  my $path = "$parent_dir/$dir";
  if (not -d $path)
  {
    mkdir $path or warn "Failed to create $path\n";
  }
}

my @programs = (
  'doas',
  'feh',
  'vlc',
  'ksh93',
  'htop',
  'fluxbox',
  'xorg',
  'yt-dlp',
  'libreoffice',
  'firefox-esr',
  'librewolf',
  'mupdf',
  'fastfetch',
  'lolcat',
  'slock',
  'wireguard-tools',
  'qbittorrent',
  'fusefs-exfat',
  'exfat-utils',
);

my $list = join ' ', @programs;
system("su -m <<EOF
pkg install -y $list
EOF");
