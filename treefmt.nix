{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    clang-format.enable = true;
    nixfmt-rfc-style.enable = true;
    rustfmt.enable = true;
  };
}
