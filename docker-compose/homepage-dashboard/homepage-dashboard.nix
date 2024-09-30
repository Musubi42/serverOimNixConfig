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

containers.homepage = {
  autoStart = true;
  privateNetwork = true;
  hostAddress = "192.168.0.40";
  localAddress = "192.168.0.42";
  hostAddress6 = "fc00::1";
  localAddress6 = "fc00::2";
  config = { config, pkgs, lib, ... }: {

    services.homepage-dashboard = {
      enable = true;
      package = pkgs.homepage-dashboard;
      openFirewall = true;
      # hostName = "localhost";
      # hostName = "homepage.musubi.dev";
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
