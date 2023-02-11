#  _   _           _         _   _        __ _                      
# | | | | ___ _ __| |__  ___| |_| |_   _ / _| |___      ___ __ ___  
# | |_| |/ _ \ '__| '_ \/ __| __| | | | | |_| __\ \ /\ / / '_ ` _ \ 
# |  _  |  __/ |  | |_) \__ \ |_| | |_| |  _| |_ \ V  V /| | | | | |
# |_| |_|\___|_|  |_.__/|___/\__|_|\__,_|_|  \__| \_/\_/ |_| |_| |_|
#                                                                   

{ config, lib, pkgs, host, ... }

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
    Mod=Mod4   # Use the super key as the main modifier
    MyTerm=alacritty
    MyBrowser=qutebrowser
    MyEditor="emacsclient -c -a emacs"
    MyPasswords="rofi-rbw"
'';

in
{
 xsession = {
   enable = true;
   numlock.enable = true;
   windowManager = {
     herbstluftwm = {
       enable = true;
       rules = {
         focus = on
	 floatplacement = smart
	 windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on
	 windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
	 windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
	 fixedsize floating=on
       };
       keybinds = {
         $Mod-Shift-q quit
         $Mod-Shift-r reload
         $Mod-Shift-c close
         $Mod-Return spawn $MyTerm 
         $Mod-e spawn $MyEditor
         $Mod-b spawn $MyBrowser
         $Mod-d spawn rofi-run
         $Mod-m spawn $MyPasswords
         # Lock screen
         $Mod-0 spawn betterlockscreen -l
         # Scratchpad
         $Mod-x spawn scratchpad
         
         # Volume control
         # Volume go up
         #hc keybind XF86AudioRaiseVolume spawn amixer sset Master 5%+
         XF86AudioRaiseVolume spawn amixer -D pulse sset Master 5%+
         $Mod-equals spawn pactl set-sink-volume @DEFAULT_SINK@ +5%
         # Volume go down
         XF86AudioLowerVolume spawn amixer -D pulse sset Master 5%-
         #hc keybind $Mod-plus spawn pactl set-sink-volume @DEFAULT_SINK@ -5%
         XF86AudioPlay spawn playerctl play-pause
         XF86AudioNext spawn playerctl next
         XF86AudioPrev spawn playerctl previous
         
         # basic movement in tiling and floating mode
         # focusing clients
         $Mod-Left  focus left
         $Mod-Down  focus down
         $Mod-Up    focus up
         $Mod-Right focus right
         $Mod-h     focus left
         $Mod-j     focus down
         $Mod-k     focus up
         $Mod-l     focus right
         
         # moving clients in tiling and floating mode
         $Mod-Shift-Left  shift left
         $Mod-Shift-Down  shift down
         $Mod-Shift-Up    shift up
         $Mod-Shift-Right shift right
         $Mod-Shift-h     shift left
         $Mod-Shift-j     shift down
         $Mod-Shift-k     shift up
         $Mod-Shift-l     shift right
         
         # splitting frames
         # create an empty frame at the specified direction
         $Mod-u       split   bottom  0.5
         $Mod-o       split   right   0.5
         # let the current frame explode into subframes
         $Mod-Control-space split explode
         
         # resizing frames and floating clients
         resizestep=0.02
         $Mod-Control-h       resize left +$resizestep
         $Mod-Control-j       resize down +$resizestep
         $Mod-Control-k       resize up +$resizestep
         $Mod-Control-l       resize right +$resizestep
         $Mod-Control-Left    resize left +$resizestep
         $Mod-Control-Down    resize down +$resizestep
         $Mod-Control-Up      resize up +$resizestep
         $Mod-Control-Right   resize right +$resizestep

         # cycle through tags
         $Mod-period use_index +1 --skip-visible
         $Mod-comma  use_index -1 --skip-visible
         
         # layouting
         $Mod-r remove
         $Mod-s floating toggle
         $Mod-f fullscreen toggle
         $Mod-Shift-f set_attr clients.focus.floating toggle
         $Mod-Shift-d set_attr clients.focus.decorated toggle
         $Mod-Shift-m set_attr clients.focus.minimized true
         $Mod-Control-m jumpto last-minimized
         $Mod-p pseudotile toggle
         # The following cycles through the available layouts within a frame, but skips
         # layouts, if the layout change wouldn't affect the actual window positions.
         # I.e. if there are two windows within a frame, the grid layout is skipped.
         $Mod-space                                                           \
                     or , and . compare tags.focus.curframe_wcount = 2                   \
                              . cycle_layout +1 vertical horizontal max vertical grid    \
                        , cycle_layout +1


       };
       mousebinds = {
         --all
         $Mod-Button1 move
         $Mod-Button2 zoom
         $Mod-Button3 resize
	};
       settings = {
	 window_gap 0
	 frame_padding 0
	 smart_window_surroundings off
	 smart_frame_surroundings on
	 mouse_recenter_gap 0
         tree_style '╾│ ├└╼─┐'
	 frame_border_active_color '#a9a9a9'
	 frame_border_normal_color '#101010cc'
	 frame_bg_normal_color '#565656aa'
	 frame_bg_active_color '#345F0Caa'
	 frame_border_width 1
	 always_show_frame on
	 frame_bg_transparent on
	 frame_transparent_width 2
	 frame_gap 9
        };
	extraConfig = {
          hc keyunbind --all
          hc rename default "${tag_names[0]}" || true
          for i in "${!tag_names[@]}" ; do
              hc add "${tag_names[$i]}"
              key="${tag_keys[$i]}"
              if [ -n "$key" ] ; then
                  hc keybind "$Mod-$key" use_index "$i"
                  hc keybind "$Mod-Shift-$key" move_index "$i"
              fi
          done
          hc attr theme.tiling.reset 1
          hc attr theme.floating.reset 1
          hc attr theme.title_height 0
          hc attr theme.title_when never
          hc attr theme.title_font 'Dejavu Sans:pixelsize=12'  # example using Xft
          # hc attr theme.title_font '-*-fixed-medium-r-*-*-13-*-*-*-*-*-*-*'
          hc attr theme.title_depth 3  # space below the title's baseline
          hc attr theme.active.color '#345F0Cef'
          hc attr theme.title_color '#ffffff'
          hc attr theme.normal.color '#323232dd'
          hc attr theme.urgent.color '#7811A1dd'
          hc attr theme.tab_color '#1F1F1Fdd'
          hc attr theme.active.tab_color '#2B4F0Add'
          hc attr theme.active.tab_outer_color '#6C8257dd'
          hc attr theme.active.tab_title_color '#ababab'
          hc attr theme.normal.title_color '#898989'
          hc attr theme.inner_width 1
          hc attr theme.inner_color black
          hc attr theme.border_width 3
          hc attr theme.floating.border_width 4
          hc attr theme.floating.outer_width 1
          hc attr theme.floating.outer_color black
          hc attr theme.active.inner_color '#789161'
          hc attr theme.urgent.inner_color '#9A65B0'
          hc attr theme.normal.inner_color '#606060'
          hc attr settings.smart_window_surroundings true
          hc attr theme.tiling.outer_width 1
          hc attr theme.background_color '#141414'
          hc unrule -F
          hc unlock
          hc detect_monitors

	};
       }
     }
   }
 }
}
