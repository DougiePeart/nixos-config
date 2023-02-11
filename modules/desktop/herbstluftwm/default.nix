#  _   _           _         _   _        __ _                      
# | | | | ___ _ __| |__  ___| |_| |_   _ / _| |___      ___ __ ___  
# | |_| |/ _ \ '__| '_ \/ __| __| | | | | |_| __\ \ /\ / / '_ ` _ \ 
# |  _  |  __/ |  | |_) \__ \ |_| | |_| |  _| |_ \ V  V /| | | | | |
# |_| |_|\___|_|  |_.__/|___/\__|_|\__,_|_|  \__| \_/\_/ |_| |_| |_|
#                                                                   

{ config, lib, pkgs, host, ... }:

let
  monitor = with host;
    if hostName == "des" then
      "${pkgs.xorg.xrandr}/bin/xrandr --output ${secondMonitor} --mode 1920x1080 --pos 0x0 --rotate normal --output ${mainMonitor} --primary --mode 1920x1080 --pos 1920x0 --rotate normal"
    else if hostName == "thicc" || hostName == "work" then
      "${pkgs.xorg.xrandr}/bin/xrandr --mode 1920x1080 --pos 0x0 --rotate normal"
    else false;
in
{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "uk";                              # Keyboard layout & €-sign
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          scrollMethod = "twofinger";
          naturalScrolling = true;                # The correct way of scrolling
          accelProfile = "adaptive";              # Speed settings
          disableWhileTyping = true;
        };
      };
      displayManager = {                          # Display Manager
        lightdm = {
          enable = true;                          # Wallpaper and GTK theme
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
          greeters = {
            gtk = {
              theme = {
                name = "Dracula";
                package = pkgs.dracula-theme;
              };
              cursorTheme = {
                name = "Dracula-cursors";
                package = pkgs.dracula-theme;
                size = 16;
              };
            };
          };
        };
        defaultSession = "none+herbstluftwm";            # none+bspwm -> no real display manager
      };
      windowManager= {
        herbstluftwm = {                                 # Window Manager
          enable = true;
        };
      };

      displayManager.sessionCommands = monitor;

      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';                                         # Used so computer does not goes to sleep

      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };

  programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on lightdm

  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    xorg.xev
    xorg.xkill
    xorg.xrandr
    xterm
    #alacritty
    #sxhkd
  ];

  xdg.portal = {                                  # Required for flatpak with window managers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}

