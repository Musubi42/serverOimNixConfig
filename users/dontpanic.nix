 { inputs, outputs, config, pkgs, lib, ... }:

{
	imports = [
		(import ../homeManagerModules/default.nix)
	];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
   git
   wget
   btop
   ctop
   nodejs_20
   corepack
   infisical
   bat
   bat-extras.batdiff
   ggshield
   go-task
   bash
   sops
   micro
   # unstable.infisical
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
