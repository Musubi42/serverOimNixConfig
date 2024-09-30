# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	  ./hardware-configuration.nix
	  #./docker-compose/oim-dockge/docker-compose.nix
	  # ./docker-compose/nextcloud/nextcloud.nix
	  # ./docker-compose/homepage-dashboard/homepage-dashboard.nix
  	  #./docker-compose/whoami/whoami.nix

      # ./modules/home-manager/default.nix
    ];
    
 #  home-manager = { 
	# extraSpecialArgs = { inherit inputs; };
	# users = {
	# import ./home.nix;
 #  };

	networking.firewall = {
	  enable = true;
	  allowedTCPPorts = [ 80 443 22 20022 ];
	  # allowedIps = [ "172.18.0.0/16" ];
	  # allowedUDPPortRanges = [
	  #   { from = 4000; to = 4007; }
	  #   { from = 8000; to = 8010; }
	  # ];
	};
	
  # security.pam.sshAgentAuth.enable
	
   users.mutableUsers = false;

   users.groups = {
   	dontpanic = {};
   	charly = {};
   };
   
   users.users.ryan = { 
     isNormalUser = true;
     hashedPasswordFile = "/etc/nixos/ryanPassword";
     createHome = true;
     homeMode = "755";
   };

   users.users.root = {
   	hashedPasswordFile = "/etc/nixos/dontpanicPassword";
   };

  # Enable Home Manager as a NixOs module
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;


  # Virtualisation
  services.qemuGuest.enable = true;
  services.qemuGuest.package = pkgs.qemu_kvm.ga;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
    	variant = "azerty";
    	layout = "fr";
   	};
  };

  # Configure console keymap
  console.keyMap = "fr";

  users.extraGroups.docker.members = [ "root" "dontpanic" ];

  virtualisation.docker = {
    # Allow dockerd to be restarted without affecting running container. This option is incompatible with docker swarm.
    liveRestore = false; 
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilogus = {
    isNormalUser = true;
    description = "ilogus";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ./authorized_key_ilo ];
    packages = with pkgs; [];
  };

  users.users.charly = {
    isNormalUser = true;
    description = "charly";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPasswordFile = "/etc/nixos/charlyPassword";
    openssh.authorizedKeys.keyFiles = [ ./authorized_key_charly ];
    packages = with pkgs; [];
  };
 
  users.users.dontpanic = {
  	isNormalUser = true;
  	extraGroups = [ "networkmanager" "wheel" "docker" ];
  	openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  	hashedPasswordFile = "/etc/nixos/dontpanicPassword";
  	# Add this block for setting DOCKER_HOST for dontpanic
 	  # shellInit = ''
 	  #   export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
 	  # '';
  };

  # users.users.root = {
  # 	# openssh.authorizedKeys.keyFiles = [  ]
  # }

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    home-manager
    # micro
    git
    openssl
    yarn-berry
    unzip
    tldr
    rPackages.whoami
    pre-commit
    fzf
    # compose2nix
    podman
    lsof
  ];

  environment.shellAliases = {
    lla = "ls -alh";
  };

  environment.variables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.cloud-init.network.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
