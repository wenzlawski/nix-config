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
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
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
          port = 587; # 465
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        passwordCommand = "security find-generic-password -s mbsync-posteo-password -w";
      };

      accounts.gmail = {
        primary = false;
        address = "marcwenzlawski@gmail.com";
        realName = "Marc Wenzlawski";
        userName = "marcwenzlawski@gmail.com";
        flavor = "gmail.com";
        imap = {
          host = "imap.gmail.com";
          port = 993;
        };
        smtp = {
          host = "smtp.gmail.com";
          port = lib.mkForce 587;
        };
        mbsync = {
          enable = false;
          create = "maildir";
        };
        lieer = {
          enable = false;
          settings = {
            ignore_tags = [];
            local_trash_tag = "deleted";
            ignore_remote_labels = [
              "CHAT"
              "IMPORTANT"
              "CATEGORY_FORUMS"
              "CATEGORY_PROMOTIONS"
              "CATEGORY_UPDATES"
              "CATEGORY_SOCIAL"
              "CATEGORY_PERSONAL"
            ];
          };
          sync = {
            enable = false;
            frequency = "*:0/5";
          };
        };
        msmtp.enable = false;
        notmuch.enable = false;
        passwordCommand = "security find-generic-password -s mbsync-gmail-password -w";
      };
    };

    contact = {
      basePath = ".contacts";
      accounts.nextcloud = {
        local = {
          type = "filesystem";
          fileExt = ".vcf";
        };
        remote = {
          userName = "mw";
          url = "https://cloud.k867.uk";
          type = "carddav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "nextcloud-mw"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = false;
          conflictResolution = "local wins";
        };
        khard = {
          enable = true;
        };
      };
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
      accounts.nextcloud = {
        local = {
          type = "filesystem";
        };
        remote = {
          userName = "mw";
          url = "https://cloud.k867.uk";
          type = "caldav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "nextcloud-mw"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = false;
          conflictResolution = "local wins";
        };
        khal = {
          enable = true;
        };
      };
    };
  };
}
