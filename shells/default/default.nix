{
  devenv-root,
  pkgs',
  pkgs,
  self,
  ...
} @ args: {
  inherit pkgs;
  inputs = builtins.removeAttrs args ["pkgs" "system"];
  modules =
    [
      # Basics
      ({
        lib,
        pkgs,
        ...
      }: {
        name = "Default shell";
        devenv.root = let
          devenvRootFileContent = builtins.readFile devenv-root.outPath;
        in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;
        packages = with pkgs; [cacert coreutils nixVersions.schemas];
        enterShell = lib.mkBefore ''
          EDITOR="''${EDITOR:-emacsclient -r}" # Default to emacs
          export EDITOR

          printf ${lib.escapeShellArg ''
            \x1B[0m
              \x1B[96m...      \x1B[34m+++
              \x1B[96m::: \x1B[34m+++  +++    \x1B[0;1mNix++ dev shell\x1B[0m
              \x1B[96m:::: \x1B[34m+++ +++
              \x1B[96m:::::: \x1B[34m+++++    \x1B[0mI'm making my own shell with linters and git hooks!
              \x1B[96m::: ::: \x1B[34m++++    \x1B[0;2mAnd bugs. So many bugs. Plz send help.\x1B[0m
              \x1B[96m:::  ::: \x1B[34m+++
              \x1B[96m:::      \x1B[34m''''
            \x1B[0m
              Loading environment ...

          ''}
        '';
      })
    ]
    ++ (self.lib.import.asList ./.);
}
