# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/12516624-1299-4d24-9ee4-27e9ef851305";
      preLVM = true;
    }
  ];

  networking.hostName = "mipro"; # Define your hostname.
  networking.extraHosts =
  ''
    192.168.1.4 nas
    192.168.1.16 vdr
    192.168.1.32 torrent
    192.168.1.35 nasn
    192.168.1.37 plex
    192.168.1.40 prox
    192.168.1.81 debct
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bc
    git
    curl
    tmux
    wget
    vim
    emacs
    tree
    psmisc
    ghc
    stack
    rustup
    gcc
    tcpdump
    firefox
    pciutils usbutils
    gimp
    hdparm
    nvme-cli
    openjdk
    ntfs3g
    gparted
    htop
    wol
    unzip
    gnumake
    binutils-unwrapped
    encfs
    zsh-powerlevel9k
    nfs-utils
    asciidoctor
    hwinfo
    screenfetch
    libreoffice-fresh
    tdesktop
    vscode
    mypaint
    autoconf
    youtube-dl
    file
    kotlin
    # mono
    # fsharp41
    dotnet-sdk
    pandoc
    texmaker
    texlive.combined.scheme-basic
    # non-free stuff
    franz
    jetbrains.idea-ultimate
    spotify
    google-chrome
  ];


  environment.variables = {
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
    POWERLEVEL9KZSH = [ "${pkgs.zsh-powerlevel9k}" ];
  };

  fonts.fonts = with pkgs; [
    ubuntu_font_family
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.adb.enable = true;
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.vim.defaultEditor = true;

  # zsh stuff
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.plugins = [ "git" "colored-man-pages" "command-not-found" "extract" ];
#  programs.zsh.ohMyZsh.theme = "bureau";
#  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  
  services.rpcbind.enable = true;

  services.autofs.enable = true;
  services.autofs.autoMaster = ''
/net -hosts local_lock=all
  '';

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

#  services.xserver.videoDrivers = [ "nvidia" ];
#  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support.
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.middleEmulation = true;
  services.xserver.libinput.tapping = true;

  #services.xserver.synaptics.enable = true;

  # Enable the KDE Desktop Environment.
#  services.xserver.displayManager.sddm.enable = true;
#  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # i3
  services.xserver.windowManager.i3.enable = true;

  # XMonad
  services.xserver.windowManager.xmonad.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.fex = {
    createHome = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "adbusers" "docker"];
    group = "users";
    home = "/home/fex";
    isNormalUser = true;
    uid = 1001;
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
