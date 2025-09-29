{ config, lib, pkgs, ... }:

let
  cfg = config.codex;
  codexVersion = "0.4.15";
  codexVsix = pkgs.fetchurl {
    url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/openai/vsextensions/chatgpt/${codexVersion}/vspackage";
    sha256 = "sha256-4Ns4EzBvkbyDL2s948ZMO8axIkeoY5lwH0tUI8AyNO0=";
  };
  codexExtension = pkgs.vscode-utils.buildVscodeExtension {
    pname = "openai-chatgpt";
    version = codexVersion;
    src = codexVsix;
  };
  codexPlatformDir =
    if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "linux-x86_64"
    else if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then "linux-aarch64"
    else throw "codex: unsupported platform ${pkgs.stdenv.hostPlatform.system}";
  codexCli = pkgs.stdenvNoCC.mkDerivation {
    pname = "codex-cli";
    version = codexVersion;
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      install -Dm755 ${codexExtension}/share/vscode/extensions/openai.chatgpt/bin/${codexPlatformDir}/codex $out/libexec/codex/bin/codex
      install -Dm755 ${codexExtension}/share/vscode/extensions/openai.chatgpt/bin/${codexPlatformDir}/rg $out/libexec/codex/bin/rg
      makeWrapper $out/libexec/codex/bin/codex $out/bin/codex \
        --suffix PATH : "$out/libexec/codex/bin" \
        --prefix PATH : ${lib.makeBinPath [ pkgs.coreutils pkgs.findutils pkgs.git pkgs.gnused pkgs.diffutils pkgs.gawk pkgs.which pkgs.ripgrep pkgs.gnugrep pkgs.patch ]}
    '';
  };
in {
  options.codex.enable = lib.mkEnableOption "Enable Codex CLI and VSCode integration.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      codexCli
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = false;
      extensions = [
        codexExtension
      ];
    };
  };
}
