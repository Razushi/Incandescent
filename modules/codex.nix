# modules/codex-minimal.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.codex.enable = lib.mkEnableOption "VS Code with mutable extensions";

  config = lib.mkIf config.codex.enable {
    # MS VS Code is unfree
    nixpkgs.config.allowUnfree = true;

    programs.vscode = {
      enable = true;
      package = pkgs.vscode; # use VSCodium only if you accept Open VSX (Codex not there)
    };

    # optional convenience
    environment.systemPackages = with pkgs; [
      vscode
    ];
  };
}
