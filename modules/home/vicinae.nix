{ inputs, ... }:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];
  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      font.size = 10;
      font.normal = "JetBrainsMono Nerd Font";
      window.opacity = 1;
    };
  };
}
