final: prev: {
  easydotnet = prev.buildDotnetGlobalTool {
    pname = "dotnet-easydotnet";
    nugetName = "EasyDotnet";
    version = "3.4.25";
    nugetHash = "sha256-RburiBDwtkNcTmzce2HHY1HJWdoOFx9x692PBd2VD9Y=";
    dotnet-sdk = prev.dotnetCorePackages.sdk_8_0;
  };
}
