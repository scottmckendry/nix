{ ... }:

{
  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "us";
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        click-method = "clickfinger";
      };
    };
  };
}
