{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # boot.loader.grup.enable = true;

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.mw = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialHashedPassword = "$y$j9T$2DyEjQxPoIjTkt8zCoWl.0$3mHxH.fqkCgu53xa0vannyu4Cue3Q7xL4CrUhMxREKC"; # Password.123
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZWQHzCPwdpFwanU6j5p+LPVPPH759mb3/4Ubl8qQ4u your_email@example.com"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZWQHzCPwdpFwanU6j5p+LPVPPH759mb3/4Ubl8qQ4u your_email@example.com"
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        colorscheme habamax
      '';

      packages.packages = {
        start = [
          pkgs.vimPlugins.nerdtree
        ];
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
