{
  description = "Unofficial installer images for NixOS using the Budgie desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    calamares-nixos-extensions = {
      url = "github:FedericoSchonborn/calamares-nixos-extensions/budgie";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          {nixpkgs.overlays = [self.overlays.default];}
        ];
      };

      packages.default = self.nixosConfigurations.${system}.config.system.build.isoImage;

      formatter = pkgs.alejandra;
    })
    // {
      overlays.default = final: prev: {
        calamares-nixos-extensions = prev.calamares-nixos-extensions.overrideAttrs (oldAttrs: {
          src = inputs.calamares-nixos-extensions;
        });
      };
    };
}
