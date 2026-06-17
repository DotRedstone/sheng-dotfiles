# ---
# Module: Rime Patches Entry
# Description: Collection and merging of all Rime configuration patches
# Scope: Home Manager
# ---

{ lib, ... }:
let
  fragments = [
    (import ./ascii-composer.nix)
    (import ./keybindings.nix)
    (import ./lua-processors.nix)
    (import ./recognizer.nix)
  ];
in
lib.foldl' lib.recursiveUpdate { } fragments
