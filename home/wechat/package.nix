# ---
# Module: WeChat - Base Package
# Description: Low-level derivation for WeChat UOS and its bridge
# Scope: Home Manager
# ---

{ pkgs }:
let
  wechat-uos = pkgs.callPackage (pkgs.path + "/pkgs/by-name/we/wechat-uos/package.nix") {
    fetchurl =
      args:
      pkgs.fetchurl (
        args
        // {
          curlOptsList = (args.curlOptsList or [ ]) ++ [
            "-H"
            "Referer: https://pro-store-packages.uniontech.com/"
          ];
        }
      );
  };

  notifyBridge = pkgs.stdenv.mkDerivation {
    pname = "wechat-notify-bridge";
    version = "0.1.0";

    src = ./bridge-rs;

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.rustc
    ];

    buildPhase = ''
      runHook preBuild
      rustc --edition=2021 -O src/main.rs -o wechat-notify-bridge
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 wechat-notify-bridge $out/bin/wechat-notify-bridge
      wrapProgram $out/bin/wechat-notify-bridge \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.libnotify
            pkgs.sqlcipher
          ]
        }
      runHook postInstall
    '';
  };
in
{
  inherit
    notifyBridge
    wechat-uos
    ;
}
