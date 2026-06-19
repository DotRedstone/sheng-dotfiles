{
  description = "dot's personal NixOS and Home Manager configuration";

  inputs = {
    # 官方包源，建议与上游保持一致使用 nixos-unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 引用 sheng 硬件仓库。普通用户只需要 clone 本仓库，
    # 不需要在本地额外 clone nixos-sheng。
    nixos-sheng = {
      url = "github:DotRedstone/nixos-sheng/sheng?dir=nixos";
      inputs.shengFirmware.follows = "shengFirmware";
    };

    # 避免在设备上通过 GitHub tarball 拉取大固件仓库时遇到截断缓存。
    shengFirmware.url =
      "git+https://github.com/DotRedstone/sheng-firmware-full.git?rev=719086ce25222dcc54920ae12409eb5d4401bbff";
  };

  outputs = { self, nixpkgs, home-manager, nixos-sheng, ... }@inputs:
  let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    # 基础配置模块，所有桌面环境共享
    shengBaseModules = [
      # 传入 inputs，方便在下游 configuration.nix 中随意调用外部 flake
      {
        _module.args.inputs = inputs;
        environment.systemPackages = [
          home-manager.packages.${system}.default
        ];
      }
      # 引入你的专属系统配置
      ./hosts/sheng/configuration.nix
      ./hosts/sheng/input-method.nix
    ];
  in {
    nixosConfigurations = {
      # 1. GNOME 桌面环境 (使用上游预设)
      # 部署命令: nh os switch ~/sheng-dotfiles -H sheng
      sheng = nixos-sheng.lib.${system}.mkShengGnomeSystem shengBaseModules;

      # 2. KDE Plasma 6 桌面环境
      # 部署命令: nh os switch ~/sheng-dotfiles -H sheng-plasma
      sheng-plasma = nixos-sheng.lib.${system}.mkShengSystem (shengBaseModules ++ [
        ./hosts/sheng/desktop/plasma.nix
      ]);

      # 3. Phosh 触屏专研桌面
      # 部署命令: nh os switch ~/sheng-dotfiles -H sheng-phosh
      sheng-phosh = nixos-sheng.lib.${system}.mkShengSystem (shengBaseModules ++ [
        ./hosts/sheng/desktop/phosh.nix
      ]);

      # 4. Hyprland 平铺窗口管理器
      # 部署命令: nh os switch ~/sheng-dotfiles -H sheng-hyprland
      sheng-hyprland = nixos-sheng.lib.${system}.mkShengSystem (shengBaseModules ++ [
        ./hosts/sheng/desktop/hyprland.nix
      ]);
    };

    # Home Manager 配置：可以通过 `home-manager switch --flake .#dot@sheng` 部署
    homeConfigurations."dot@sheng" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home/dot.nix
        inputs.nixvim.homeModules.nixvim
      ];
    };
  };
}
