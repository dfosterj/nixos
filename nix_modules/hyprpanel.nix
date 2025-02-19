{ config, lib, pkgs, ... }:

let
  hyprpanel-overlay = self: super: {
    hyprpanel = super.callPackage (super.fetchFromGitHub {
      owner = "Jas-SinghFSU";
      repo = "HyprPanel";
      rev = "9b342341fe17e4fb2c4cad9e3379a814a6a73097";
      sha256 = "12mfl0ah9hj91q4lb6y3fjhsygx98lgi7ij3qvpr69aq235bc11r";
    }) {};
  };

  pkgsWithOverlay = pkgs.extend hyprpanel-overlay;

in {
  options = {
    hyprpanel.enable = lib.mkEnableOption "Enable HyprPanel";
  };

  config = lib.mkIf config.hyprpanel.enable {
    nixpkgs.overlays = [ hyprpanel-overlay ];

    environment.systemPackages = with pkgsWithOverlay; [
      hyprpanel
    ];
  };
}
