#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./des OR ./thicc OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, home-manager, nur, user, location, doom-emacs, hyprland, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  des = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "des";
        mainMonitor = "HDMI-A-3";
        secondMonitor = "DP-1";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      hyprland.nixosModules.default
      ./des
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user doom-emacs;
          host = {
            hostName = "des";     #For Xorg iGPU  | Videocard 
            mainMonitor = "HDMI-A-3"; #HDMIA3         | HDMI-A-1
            secondMonitor = "DP-1";   #DP1            | DisplayPort-1
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./des/home.nix)];
        };
      }
    ];
  };

  thicc = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "thicc";
        mainMonitor = "eDP-1";
      };
    };
    modules = [
      #herbstluftwm.nixosModules.default
      ./thicc
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "thicc";
            mainMonitor = "eDP-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./thicc/home.nix)];
        };
      }
    ];
  };

  work = lib.nixosSystem {                                  # Work profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "work";
        mainMonitor = "eDP-1";
        secondMonitor = "HDMI-A-2";
      };
    };
    modules = [
      hyprland.nixosModules.default
      ./work
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "work";
            mainMonitor = "eDP-1";
            secondMonitor = "HDMI-A-2";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./work/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
      };
    };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "vm";
            mainMonitor = "Virtual-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };
}
