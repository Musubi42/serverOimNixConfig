{
  description = "Dontpanic NixOS configuration";

  # compose2nix.url = "github:aksiksi/compose2nix";
  # compose2nix.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, vscode-server, ... }:
   let
     lib = nixpkgs.lib;
   in
   {
    # overlays = import ./overlays {inherit inputs;};
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        # overlays = import ./overlays {inherit inputs;};
        # specialArgs = { inherit inputs system; };
        modules = [
          ./configuration.nix

          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
          
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            
            # home-manager.users.ryan = lib.mkDefault (import ./users/ryan.nix);
            
            home-manager.users.dontpanic = import ./users/dontpanic.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };

    homeManagerModules.default = ./homeManagerModules;
    
  };
}
