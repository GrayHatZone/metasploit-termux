#!/data/data/com.termux/files/usr/bin/bash
clear

RED="\033[91m"
GREEN="\033[92m"
YELLOW="\033[93m"
BLUE="\033[94m"
MAGENTA="\033[95m"
WHITE="\033[97m"
RESET="\033[37m"

pkg up -y
clear
pkg i git python wget cowsay -y
pip install lolcat
mkdir $PREFIX/opt
clear
cowsay "Metasploit in Termux! by #D4RK-CL0UD" | lolcat
echo
echo -e "${MAGENTA}[${BLUE}*${MAGENTA}] ${GREEN}Dependencies installation...${RESET}\n"
rm $PREFIX/etc/apt/sources.list.d/*
apt purge ruby -y
rm -fr $PREFIX/lib/ruby/gems
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"
python3 -m pip install --upgrade pip
python3 -m pip install requests
source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)
rm -rf $PREFIX/opt/metasploit-framework
clear
echo -e "${MAGENTA}[${BLUE}*${MAGENTA}] ${GREEN}Downloading...${RESET}\n"
cd $PREFIX/opt
git clone https://github.com/rapid7/metasploit-framework.git --depth=1
echo
echo -e "${MAGENTA}[${BLUE}*${MAGENTA}] ${GREEN}Installation...${RESET}\n"
cd $PREFIX/opt/metasploit-framework
gem install bundler
declare NOKOGIRI_VERSION=$(cat Gemfile.lock | grep -i nokogiri | sed 's/nokogiri [\(\)]/(/g' | cut -d ' ' -f 5 | grep -oP "(.).[[:digit:]][\w+]?[.].")
gem install nokogiri -v $NOKOGIRI_VERSION -- --use-system-libraries
bundle config build.nokogiri "--use-system-libraries --with-xml2-include=$PREFIX/include/libxml2"; bundle install
gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j$(nproc --all)

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
if [ -e $PREFIX/bin/msfrpcd ];then
	rm $PREFIX/bin/msfrpcd
fi

ln -s $PREFIX/opt/metasploit-framework/msfconsole $PREFIX/bin/
ln -s $PREFIX/opt/metasploit-framework/msfvenom $PREFIX/bin/
ln -s $PREFIX/opt/metasploit-framework/msfrpcd $PREFIX/bin/

termux-elf-cleaner $PREFIX/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so

sed -i '86 {s/^/#/};96 {s/^/#/}' $PREFIX/lib/ruby/gems/3.1.0/gems/concurrent-ruby-1.0.5/lib/concurrent/atomic/ruby_thread_local_var.rb
sed -i '442, 476 {s/^/#/};436, 438 {s/^/#/}' $PREFIX/lib/ruby/gems/3.1.0/gems/logging-2.3.1/lib/logging/diagnostic_context.rb

echo
echo "==========================================="
echo -e "\033[32m Installation complete. \n Launch metasploit by executing: msfconsole\033[0m"
echo "==========================================="
