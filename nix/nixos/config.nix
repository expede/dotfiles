{ config, lib, pkgs, hostname, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
 #     <home-manager/nixos>
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

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  documentation.enable = false; # expede: Fixes build on 22.11

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
  hardware.opengl.extraPackages = [pkgs.vaapiVdpau];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "repl-flake"
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.expede = {
    isNormalUser = true;
    description = "Brooklyn Zelenka";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      git
      gh
      _1password
    ];
  };

 # home-manager.users.expede = import /home/expede/Documents/dotfiles/nixpkgs/home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.compiz-windows-effect
    tailscale
    wget
    vim
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
    openssh.enable   = true;
    tailscale.enable = true;
  };

  # expede:
  # create a oneshot job to authenticate to Tailscale
systemd.services.tailscale-autoconnect = {
  description = "Automatic connection to Tailscale";

  # make sure tailscale is running before trying to connect to tailscale
  after = [ "network-pre.target" "tailscale.service" ];
  wants = [ "network-pre.target" "tailscale.service" ];
  wantedBy = [ "multi-user.target" ];

  # set this service as a oneshot job
  serviceConfig.Type = "oneshot";

  # have the job run this shell script
  script = with pkgs; ''
    # wait for tailscaled to settle
    sleep 2

    # check if we are already authenticated to tailscale
    status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
    if [ $status = "Running" ]; then # if so, then do nothing
      exit 0
    fi

    # otherwise authenticate with tailscale
    ${tailscale}/bin/tailscale up -authkey tskey-auth-kejokE6CNTRL-rSHKwrvyq2iitQRPhth4zhStFEikfzXVj
  '';
};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

# expede:
# networking.firewall = {
#   enable           = true;
#   checkReversePath = "loose";
#
#   # always allow traffic from your Tailscale network
#   trustedInterfaces = [ "tailscale0" ];
#
#   # allow the Tailscale UDP port through the firewall
#   allowedUDPPorts = [ config.services.tailscale.port ];
#
#   # allow you to SSH in over the public internet
#   allowedTCPPorts = [ 22 ];
# };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
