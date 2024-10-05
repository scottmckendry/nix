{ username, hostname, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = hostname;
}
