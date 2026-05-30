final: prev: {
  easydotnet = prev.buildDotnetGlobalTool {
    pname = "dotnet-easydotnet";
    nugetName = "EasyDotnet";
    version = "3.2.2";
    nugetHash = "sha256-EX8RnhRUVwm/LPOob1t6407j0SNpAErgZ3QMv0KDJCI=";
    dotnet-sdk = prev.dotnetCorePackages.sdk_8_0;
  };
}
