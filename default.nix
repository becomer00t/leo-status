{
  rustPlatform,
  lib,
  pkgs,
}: let
  cargoToml = lib.importTOML ./leo-status/Cargo.toml;
  packageVersion = cargoToml.package.version;
in rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leo-status";
  version = packageVersion;

  src = lib.cleanSource ./.;

  buildInputs = with pkgs; [
    libusb1
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config # required for rust usb library
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "leo-status is a tool for monitoring a Leo Bodnar GPSDO. It exposes a HTTP endpoint with the GPSDO status and config.";
    homepage = "https://github.com/becomer00t/leo-status";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
