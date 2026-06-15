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

    # 直接引用远程 GitHub 上的硬件仓库，并指定 flake.nix 所在的子目录
    xiaomi-sheng.url = "github:DotRedstone/nixos-xiaomi-sheng?dir=nixos";
  };

  outputs = { self, nixpkgs, home-manager, xiaomi-sheng, ... }@inputs: 
  let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # System 配置：可以通过 `nixos-rebuild switch --flake .#sheng` 部署
    nixosConfigurations.sheng = xiaomi-sheng.lib.${system}.mkShengGnomeSystem [
      # 传入 inputs，方便在下游 configuration.nix 中随意调用外部 flake
      {
        _module.args.inputs = inputs;
        environment.systemPackages = [
          home-manager.packages.${system}.default
        ];
      }
      # 引入你的专属系统配置
      ./hosts/sheng/configuration.nix
    ];

    # Home Manager 配置：可以通过 `home-manager switch --flake .#dot@sheng` 部署
    homeConfigurations."dot@sheng" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home/dot.nix
      ];
    };
  };
}
