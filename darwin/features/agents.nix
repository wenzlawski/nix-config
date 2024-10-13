{
  pkgs,
  config,
  ...
}: {
  launchd.user.agents = {
    notmuch.serviceConfig = {
      Label = "de.mw.notmuch-email";
      ProgramArguments = [
        "${pkgs.notmuch}/bin/notmuch"
        "new"
      ];
      StandardErrorPath = "/tmp/notmuch_mw.err.log";
      StandardOutPath = "/tmp/notmuch_mw.out.log";
      RunAtLoad = true;
      StartInterval = 60;
    };
    msmtpq.serviceConfig = {
      Label = "de.mw.msmtpq-send";
      EnvironmentVariables = {
        "MSMTP_QUEUE" = "/Users/mw/.local/share/msmtp/queue";
        "EMAIL_CONN_TEST" = "n";
        "EMAIL_QUEUE_QUIET" = "t";
      };
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "exec $HOME/.nix-profile/bin/msmtpq --q-mgmt -r"
      ];
      StandardErrorPath = "/tmp/msmtpq_mw.err.log";
      StandardOutPath = "/tmp/msmtpq_mw.out.log";
      RunAtLoad = true;
      StartInterval = 150;
    };
    vdirsyncer.serviceConfig = {
      Label = "de.mw.vdirsyncer-sync";
      ProgramArguments = [
        "${pkgs.vdirsyncer}/bin/vdirsyncer"
        "sync"
      ];
      StandardErrorPath = "/tmp/vdirsyncer_mw.err.log";
      StandardOutPath = "/tmp/vdirsyncer_mw.out.log";
      StartInterval = 150;
      RunAtLoad = true;
    };
    borg.serviceConfig = {
      Label = "de.mw.borgbackup-remote";
      EnvironmentVariables = {
        "PATH" = "/usr/local/bin";
      };
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "exec $HOME/.local/bin/borg_backup.sh"
      ];
      StandardErrorPath = "/tmp/borg_mw.err.log";
      StandardOutPath = "/tmp/borg_mw.out.log";
      RunAtLoad = true;
      StartCalendarInterval = [
        {
          Hour = 20;
          Minute = 0;
        }
      ];
    };
    darkMode.serviceConfig = {
      Label = "de.mw.darkMode-enable";
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "exec $HOME/.local/bin/enable_dark.sh"
      ];
      StandardErrorPath = "/tmp/dark_mw.err.log";
      StandardOutPath = "/tmp/dark_mw.out.log";
      StartCalendarInterval = [
        {
          Hour = 18;
          Minute = 0;
        }
      ];
    };
  };
}
