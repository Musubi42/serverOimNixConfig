{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  programs.git = {
   # package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "dontpanice";
    userEmail = "raphaelthi59@gmail.com";

    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/serverOimNix_GithubOim";
    };
    # aliases = {
    #   co = "checkout";
    #   ci = "commit";
    #   cia = "commit --amend";
    #   s = "status";
    #   st = "status";
    #   b = "branch";
    #   # p = "pull --rebase";
    #   pu = "push";
    # };
    # iniContent = {
    #   # Branch with most recent change comes first
    #   branch.sort = "-committerdate";
    #   # Remember and auto-resolve merge conflicts
    #   # https://git-scm.com/book/en/v2/Git-Tools-Rerere
    #   rerere.enabled = true;
    # };
    # ignores = [ "*~" "*.swp" ];
    # lfs.enable = true;
    # delta = {
    #   enable = true;
    #   options = {
    #     features = "decorations";
    #     navigate = true;
    #     light = false;
    #     side-by-side = true;
    #   };
    # };
    # extraConfig = {
    #   init.defaultBranch = "master"; # Undo breakage due to https://srid.ca/luxury-belief
    #   core.editor = "nvim";
    #   #protocol.keybase.allow = "always";
    #   credential.helper = "store --file ~/.git-credentials";
    #   pull.rebase = "false";
    # };
  };
}
