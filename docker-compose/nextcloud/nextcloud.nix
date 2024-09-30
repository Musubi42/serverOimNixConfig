# Auto-generated using compose2nix v0.2.2.
{ pkgs, lib, ... }:

{

networking.nat = {
  enable = true;
  internalInterfaces = ["ve-+"];
  externalInterface = "ens3";
  # Lazy IPv6 connectivity for the container
  enableIPv6 = true;
};

containers.nextcloud = {
  autoStart = true;
  privateNetwork = true;
  hostAddress = "192.168.100.10";
  localAddress = "192.168.100.11";
  hostAddress6 = "fc00::1";
  localAddress6 = "fc00::2";
  config = { config, pkgs, lib, ... }: {

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      # hostName = "localhost";
      hostName = "nextcloud.musubi.dev";
      config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
    };

    system.stateVersion = "23.11";

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 ];
      };
      # Use systemd-resolved inside the container
      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
      useHostResolvConf = lib.mkForce false;
    };
    
    services.resolved.enable = true;

  };
};
}
