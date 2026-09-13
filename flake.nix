{
  description = "Command-line interface for Volvelle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    volvelle-shell = {
      url = "git+ssh://git@github.com/arcane-semantics/volvelle-shell?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.volvelle-cli.follows = "";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs platforms lists systems;

    pkgsOf = nixpkgs.legacyPackages;
    systems' = lists.intersectLists platforms.linux systems.flakeExposed;
    eachSystem = genAttrs systems';
  in {
    formatter = eachSystem (system: pkgsOf.${system}.alejandra);

    packages = eachSystem (system: rec {
      volvelle-cli = pkgsOf.${system}.callPackage ./default.nix {
        rev = self.rev or self.dirtyRev;
        volvelle-shell = inputs.volvelle-shell.packages.${system}.default;
      };
      with-shell = volvelle-cli.override {withShell = true;};
      default = volvelle-cli;
    });

    devShells = eachSystem (system: {
      default = pkgsOf.${system}.mkShellNoCC {
        packages = [self.packages.${system}.with-shell];
      };
    });
  };
}
