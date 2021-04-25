# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).



{ config, pkgs, ... }:

let
  # KUF: This setup make the use of the release explicit in the config (pinning nixpkgs).
  # This setup also allows to use stable and unstable in parallel.
  # - https://discourse.nixos.org/t/installing-only-a-single-package-from-unstable/5598/2
  # - https://nix.dev/reference/pinning-nixpkgs.html
  pkgs = import (builtins.fetchTarball("channel:nixos-20.09")) { config = { allowUnfree = true; }; };
  unstable = import (builtins.fetchTarball("channel:nixos-unstable")) { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


# {
#   imports =
#     [ # Include the results of the hardware scan.
#       ./hardware-configuration.nix
#     ];  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Always use the newest kernel

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # detect Mic
  #  boot.kernelParams = ["snd_hda_intel.dmic_detect=0"];
     boot.kernelParams = ["snd-intel-dspcfg.dsp_driver=1"];
     boot.extraModprobeConfig = "options snd slots=,snd_usb_audio";
     
   networking.hostName = "persephone"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
   time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # enable zsh

  
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
    theme = "dst";
  };

    users.extraUsers.adisbladis = {
      shell = pkgs.zsh;
    };

    
  programs.zsh.enable = true;

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  services.fwupd.enable = true;

  services = {
  xserver = {
    enable = true;
    layout = "de";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome3.enable = true;
  };

  dbus.packages = [ pkgs.gnome3.dconf ];
  udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
};

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;
   services.xserver.libinput.naturalScrolling = true;
   services.xserver.libinput.middleEmulation = true;
   services.xserver.libinput.tapping = true;
  # services.xserver.synaptics.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.rabea = {
     isNormalUser = true;
     home = "/home/rabea";
     extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
   };
  # never type password
  security.sudo.wheelNeedsPassword = false;

  # enable unfree packages
    nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [

   git
   firefox
   chromium


   emacs
   wget vim 

   tmux
   htop
   openconnect
   zsh

   lxrandr
   baobab
   bzip2
   ffmpeg-full
   pavucontrol
   pamixer
   pdfgrep
   procmail
   rdesktop
   redshift
   reiserfsprogs
   unstable.restic
   unstable.obs-studio

   feh
   flac
   gnome3.gedit
   imagemagick
   lame
   mosh
   mutt
   msmtp
   isync
   mpv
   mlt
   notmuch
   gparted
   pdfgrep
   

   gparted
    
   unstable.zoom-us 
   gnome3.cheese
   restic

   networkmanager
   networkmanagerapplet


   python38
   python38Packages.python-gitlab
   python38Packages.jupyter
   python38Packages.jupyter_core 
   python38Packages.pandas
   python38Packages.pip
   python38Packages.requests
   python38Packages.beautifulsoup4
   python38Packages.numpy
   python38Packages.scipy
   python38Packages.nltk
   python38Packages.spacy
   
   conda
   spyder
   jupyter

   pandoc

   
   unstable.pulseaudio
   unstable.sof-firmware

   ponysay
   cowsay

];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

