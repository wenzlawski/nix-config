{
  config,
  pkgs,
  ...
}: {
  home.file.".config/git/config-sharefile.inc".text = ''
    [user]
      email = "marc.wenzlawski@gmail.com"
  '';

  programs.git = {
    enable = true;
    userName = "Marc Wenzlawski";
    userEmail = "marc.wenzlawski@gmail.com";
    aliases = {
      upstream-name = "!git remote | egrep -o '(upstream|origin)' | tail -1";
      head-branch = "!basename $(git symbolic-ref refs/remotes/$(git upstream-name)/HEAD)";
      cm = "!git checkout $(git head-branch)";
      co = "checkout";
      cob = "checkout -b";
      cprev = "checkout @{-1}";
      repo-root = "rev-parse --show-toplevel";
      rr = "rev-parse --show-toplevel";
    };

    includes = [
      {
        path = "~/.config/git/config-sharefile.inc";
        condition = "gitdir:~/work/";
      }
    ];

    ignores = [
      ".direnv/"
      "*.swp"
      ".idea/"
      ".DS_Store"
    ];

    extraConfig = {
      init.defaultBranch = "main";
    };

    difftastic = {
      enable = true;
    };
  };
}
