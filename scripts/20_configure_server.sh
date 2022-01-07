
#set timezone to BST
export TZ=Europe/London
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#update bash profile with paths and aliases
cat << 'EOF' >> /root/.bashrc
export HISTTIMEFORMAT="%d/%m/%y %T "


#source aliases
for f in /opt/hmpps/aliases/*.sh; do
   source "$f" -H
done


EOF
