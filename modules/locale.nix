{ ... }:

{
  services.automatic-timezoned.enable = true;

  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    supportedLocales = [
      "en_NZ.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };

}
