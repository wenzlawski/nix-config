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
        primary = true;
        address = "marc.wenzlawski@icloud.com";
        realName = "Marc Wenzlawski";
        userName = "marc.wenzlawski@icloud.com";
        # gpg = {
        #   key = "";
        #   signByDefault = true;
        # };
        imap = {
          host = "imap.mail.me.com";
          port = 993;
          tls = {
            enable = true;
          };
        };
        smtp = {
          host = "smtp.mail.me.com";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        signature = {
          text = ''
            Mit besten Wuenschen
            Marc Wenzlawski
          '';
          showSignature = "append";
        };
        passwordCommand = "security find-generic-password -s mbsync-icloud-password -w";
      };

      accounts.posteo = {
        address = "marcwenzlawski@posteo.com";
        realName = "Marc Wenzlawski";
        userName = "marcwenzlawski@posteo.com";
        imap = {
          host = "posteo.de";
          port = 993;
        };
        smtp = {
          host = "posteo.de";
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
