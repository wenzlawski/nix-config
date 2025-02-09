{...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent=yes
    '';

    matchBlocks = {
      "borg" = {
        user = "u411549-sub1";
        hostname = "u411549.your-storagebox.de";
        identityFile = "~/.ssh/id_ed25519_hetznerbackup";
        port = 23;
      };
      "storage" = {
        user = "u411549-sub2";
        hostname = "u411549.your-storagebox.de";
        identityFile = "~/.ssh/id_ed25519";
        port = 23;
      };
      "k" = {
        user = "mw";
        hostname = "188.245.177.59";
        identityFile = "~/.ssh/id_ed25519";
      };
      "rk" = {
        user = "root";
        hostname = "188.245.177.59";
        identityFile = "~/.ssh/id_ed25519";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          "AddKeysToAgent" = "yes";
          "UseKeychain" = "yes";
        };
      };
    };
  };
}
