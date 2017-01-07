#!/bin/bash

set -x

#count new mail for every maildir
maildirnew="$HOME/.mail/*/*/new/"
new="$(find $maildirnew -type f | wc -l)"

#count old mail for every maildir
maildirold="$HOME/.mail/*/*/cur/"
old="$(find $maildirold -type f | wc -l)"


while true
#sleep 1m
do
    #mbsync -aV  >> /tmp/.mbsync.log 2>&1
    #mbsync -a  >> /tmp/.mbsync.log 2>&1
    #mbsync -aVn  >> /tmp/.mbsync.log 2>&1
    #echo '#####################################' >> /tmp/.mbsync.log
    #echo '########## Ran time :' `date +"%T"` >> /tmp/.mbsync.log
    #notify-send --urgency=critical -t 100 'Mail' 'Mbsync IMAP Done!!!'
    #echo '########## Sleep 4 Minutes ##########' >> /tmp/.mbsync.log
    #echo '#####################################' >> /tmp/.mbsync.log
    if [ $new -gt 0 ] 
    then
    #    export DISPLAY=:0; export XAUTHORITY=~/.Xauthority; 
    #    notify-send -a --urgency=critical -t 10000 "Mbsync" "New mail!\nNew: $new Old: $old"
    #     echo "Mbsync" "New mail!\nNew: $new Old: $old"
         echo $new > ~/.config/awesome/mail-config 2>&1
    #    #/home/kenan/.scripts/maildir-notification loop
    #    #/home/kenan/.scripts/maildir-notification notify
    fi

    sleep 1m
done
