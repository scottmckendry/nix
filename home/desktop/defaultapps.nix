{ ... }:
let
  browser = "zen";
  terminal = "kitty";
  filemanager = "yazi";
in
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "${browser}.desktop" ];
        "x-scheme-handler/http" = [ "${browser}.desktop" ];
        "x-scheme-handler/https" = [ "${browser}.desktop" ];
        "x-scheme-handler/about" = [ "${browser}.desktop" ];
        "application/pdf" = [ "${browser}.desktop" ];
        "image/png" = [ "${browser}.desktop" ];
        "image/jpeg" = [ "${browser}.desktop" ];
        "image/gif" = [ "${browser}.desktop" ];
        "image/webp" = [ "${browser}.desktop" ];
        "image/svg+xml" = [ "${browser}.desktop" ];
        "x-scheme-handler/terminal" = [ "${terminal}.desktop" ];
        "inode/directory" = [ "${filemanager}.desktop" ];
      };
    };
  };
}
