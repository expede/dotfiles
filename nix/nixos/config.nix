{ config, lib, pkgs, hostname, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    # Shared nix configuration
    ../config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint      = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-c0b45b46-fd32-4f13-b237-a5c5d666f1f6".device = "/dev/disk/by-uuid/c0b45b46-fd32-4f13-b237-a5c5d666f1f6";
  boot.initrd.luks.devices."luks-c0b45b46-fd32-4f13-b237-a5c5d666f1f6".keyFile = "/crypto_keyfile.bin";

  powerManagement.enable = true;

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable        = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # documentation.enable = false; # expede: Fixes build on 22.11

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];
  hardware.graphics = {
    enable        = true;
    enable32Bit   = true;
  };

  # Enable the GNOME Desktop Environment.
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable media server
  services.jellyfin = {
    enable = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.expede = {
    isNormalUser = true;
    description = "Brooklyn Zelenka";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      pkgs.firefox-devedition
      pkgs.git
      pkgs.gh
      pkgs.github-copilot-cli
      pkgs._1password-cli
      pkgs.localsearch
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.compiz-windows-effect
    pkgs.gnomeExtensions.proton-vpn-button
    pkgs.protonvpn-gui
    pkgs.tailscale
    pkgs.wget
    pkgs.vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      settings = {};
    };
    tailscale.enable = true;
  };


  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8096 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.transmission = {
    enable  = true;
    package = pkgs.transmission_4;
  };

  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall      = true;
      dedicatedServer.openFirewall = true;
    };

    hyprland.enable = true;
  };

  fonts.packages = [
    pkgs.dina-font
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.liberation_ttf
    pkgs.mplus-outline-fonts.githubRelease
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
    pkgs.proggyfonts
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
