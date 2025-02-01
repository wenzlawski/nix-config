{
  self,
  pkgs,
  config,
  ...
}: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    configureRedis = true;
    hostName = "cloud.k867.uk";
    https = false;
    autoUpdateApps.enable = true;
    maxUploadSize = "1G";
    database.createLocally = true;
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      # List of apps we want to install and are already packaged in
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      # inherit calendar mail notes tasks;
    };

    config = {
      dbtype = "mysql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      adminpassFile = "/etc/nixos/password.txt";
      adminuser = "root";
      trustedProxies = ["localhost" "127.0.0.1" "188.245.177.59" "cloud.k867.uk"];
      extraTrustedDomains = ["cloud.k867.uk"];
      overwriteProtocol = "https";
      defaultPhoneRegion = "DE";
    };

    settings = {
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
    };
  };

  systemd.services.nextcloud-setup.serviceConfig = {
    RequiresMountsFor = ["/var/lib/nextcloud"];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # ensureDatabases = [
    #   "nextcloud"
    # ];
    # ensureUsers = [
    #   {
    #     name = "nextcloud";
    #     ensurePermissions = {
    #       "nextcloud.*" = "ALL PRIVILEGES";
    #     };
    #   }
    # ];
  };

  systemd.services."nextcloud-update-db" = {
    requires = ["mysql.service"];
    after = ["mysql.service"];
  };

  systemd.services."nextcloud-setup" = {
    requires = ["mysql.service"];
    after = ["mysql.service"];
  };

  # services.onlyoffice = {
  #   enable = true;
  #   hostname = "onlyoffice.k867.uk";
  # };

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = ["nextcloud"];
  #   ensureUsers = [
  #     {
  #       name = "nextcloud";
  #       ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
  #     }
  #   ];
  # };

  # systemd.services."nextcloud-setup" = {
  #   requires = ["postgresql.service"];
  #   after = ["postgresql.service"];
  # };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
    virtualHosts."test.k867.uk" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "200 '<html><body><h1>hello</h1></body></html>'";
        extraConfig = "add_header Content-Type text/html;";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "marcwenzlawski+acme@posteo.com";
    defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    certs = {
      ${config.services.nextcloud.hostName} = {
        group = config.services.nginx.group;
      };
      "test.k867.uk" = {
        group = config.services.nginx.group;
      };
    };
  };
}
