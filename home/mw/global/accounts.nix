{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  accounts = {
    email = {
      accounts.icloud = {
        address = "marc.wenzlawski@icloud.com";
        realName = "Marc Wenzlawski";
        userName = "marc.wenzlawski@icloud.com";

        imap = {
          host = "imap.mail.me.com";
          port = 993;
        };
        smtp = {
          host = "smtp.mail.me.com";
          port = 587;
          tls = {
            enable = true;
            useStartTls = true; # need to, breaks otherwise
          };
        };
        mbsync = {
          enable = false;
          create = "maildir";
        };
        msmtp.enable = false;
        notmuch.enable = false;
        passwordCommand = "security find-generic-password -s mbsync-icloud-password -w";
      };

      accounts.posteo = {
        primary = true;
        address = "marcwenzlawski@posteo.com";
        realName = "Marc Wenzlawski";
        userName = "marcwenzlawski@posteo.com";
        imap = {
          host = "posteo.de";
          port = 993;
        };
        smtp = {
          host = "posteo.de";
          port = 465;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        passwordCommand = "security find-generic-password -s mbsync-posteo-password -w";
      };
    };

    contact = {
      basePath = ".contacts";
      accounts.posteo = {
        local = {
          type = "filesystem";
          fileExt = ".vcf";
        };
        remote = {
          userName = "marcwenzlawski@posteo.com";
          url = "https://posteo.de:8843/addressbooks/marcwenzlawski/default";
          type = "carddav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "posteo-mail"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = true;
          conflictResolution = "local wins";
        };
        khard = {
          enable = true;
        };
      };
    };

    calendar = {
      basePath = ".calendar";
      accounts.posteo = {
        local = {
          type = "filesystem";
        };
        remote = {
          userName = "marcwenzlawski@posteo.com";
          url = "https://posteo.de:8443/calendars/marcwenzlawski/default";
          type = "caldav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "posteo-mail"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = true;
          conflictResolution = "local wins";
        };
        khal = {
          enable = true;
        };
      };
    };
  };
}
