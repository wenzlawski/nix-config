{
  pkgs,
  config,
  ...
}: {
  system.defaults.CustomUserPreferences."org.mozilla.librewolf" = {
    EnterprisePoliciesEnabled = true;
    AppAutoUpdate = true;
  };
}
