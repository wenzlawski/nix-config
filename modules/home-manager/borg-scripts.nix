{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.borg-scripts;
  package = pkgs.borg-scripts;
in {
  # TODO: Pass config variables to the scripts.
  options.programs.borg-scripts = {
    enable = lib.mkEnableOption "borg-scripts";

    defaultServer = lib.mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
        Borg scripts
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [package];
      sessionVariables.XPO_SERVER = lib.optionalString (cfg.defaultServer != null) cfg.defaultServer;
    };
  };
}
