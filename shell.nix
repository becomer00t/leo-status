{
  pkgs,
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustPackages.clippy
    git
  ];
}