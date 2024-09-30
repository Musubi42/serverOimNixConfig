{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    micro
  ];

  programs.micro = {
    enable = true;
    # https://github.com/zyedidia/micro/blob/master/runtime/help/options.md 
	settings = {
	  tabsize = 2;
	  autosu = false;
      cursorline = false;
	};
  };
}

