#  _   _           _         _   _        __ _                      
# | | | | ___ _ __| |__  ___| |_| |_   _ / _| |___      ___ __ ___  
# | |_| |/ _ \ '__| '_ \/ __| __| | | | | |_| __\ \ /\ / / '_ ` _ \ 
# |  _  |  __/ |  | |_) \__ \ |_| | |_| |  _| |_ \ V  V /| | | | | |
# |_| |_|\___|_|  |_.__/|___/\__|_|\__,_|_|  \__| \_/\_/ |_| |_| |_|
#                                                                   

{ config, lib, pkgs, host, ... };

let
  extra = ''
    xsetroot -solid '#5A8E3A'

    picom --config ~/.config/picom/picom.conf &
    killall -q conky &
    killall -q pasystray &
    #conky &
    bash /home/dougie/bin/polybar.sh &
    emacs --daemon &
    #feh --bg-scale /home/dougie/media/backgrounds/by_upload2_2560.jpg &
    nitrogen --restore &
    bash /home/dougie/.screenlayout/docked.sh
    setxkbmap gb
    pasystray &
'';

in
{
 xsession = {
   enable = true;
   numlock.enable = true;
   windowManager = {
     herbstluftwm = {
       enable = true;
       rules =;
       keybinds =;
       mousebinds =;
       settings =;


       }
     }
   }
 }
}
