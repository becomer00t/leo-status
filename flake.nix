{
  description = "leo-status is a tool for monitoring a Leo Bodnar GPSDO. It exposes a HTTP endpoint with the GPSDO status and config.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils?ref=11707dc2f618dd54ca8739b309ec4fc024de578b";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    # OS independent module configuration
    nixosModules = {
      default = import ./module.nix {
        flakePackages = self.packages;
      };
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    # System specific configuration
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = {
        leo-status = pkgs.callPackage ./default.nix {};
        default = self.packages.${system}.leo-status;
      };

      devShells = {
        default = import ./shell.nix {
          inherit pkgs;
        };
      };
    }
  );
}
