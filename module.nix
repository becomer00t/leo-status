{ flakePackages }:
{ config, lib, pkgs, ... }: let
  cfg = config.services.leo-status;
in {
  options.services.leo-status = {
    enable = lib.mkEnableOption "enable the leo-status service";

    package = lib.mkOption {
      type = lib.types.package;
      default = flakePackages.${pkgs.system}.leo-status;
      description = "leo-status package to use";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "5s";
      description = "interval to poll the gpsdo";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:8234";
      description = "address to host the http service on";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.leo-status = {
      description = "leo-status gpsdo monitor";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/leo-status --interval ${cfg.interval} --http-host ${cfg.host}";
        Restart = "on-failure";
        RestartSec = "30s";
        Type = "exec";
      };
    };
  };
}
