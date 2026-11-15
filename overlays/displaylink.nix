# make the displaylink package buildable headlessly.
final: prev:
let
  src = (prev.displaylink.override { requireFile = args: args; }).src;

  zipUrl =
    let
      matches = builtins.match ".*(https://www\.synaptics\.com/sites/default/files/exe_files/[^ \n]+).*" src.message;
    in
    if matches == null then
      throw ''
        displaylink overlay: could not extract a Synaptics download URL from
        the upstream message. The nixpkgs displaylink message format may have
        changed. Message was:

        ${src.message}
      ''
    else
      builtins.head matches;
in
{
  displaylink = prev.displaylink.overrideAttrs (old: {
    src = final.fetchurl {
      inherit (src) name hash;
      url = zipUrl;
    };
  });
}
