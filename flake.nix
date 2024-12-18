{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
  };
  outputs = {
    self,
    flake-utils,
    opam-nix,
    nixpkgs,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      package = "learn";
      pkgs = nixpkgs.legacyPackages.${system};
      on = opam-nix.lib.${system};
      localPackagesQuery =
        builtins.mapAttrs (_: pkgs.lib.last)
        (on.listRepo (on.makeOpamRepo ./.));
      devPackagesQuery = {
        # You can add "development" packages here. They will get added to the devShell automatically.
        ocaml-lsp-server = "*";
        ocamlformat = "*";
        utop = "*";
      };
      query =
        devPackagesQuery
        // {
          ## You can force versions of certain packages here, e.g:
          ## - force the ocaml compiler to be taken from opam-repository:
          ocaml-base-compiler = "*";
          ## - or force the compiler to be taken from nixpkgs and be a certain version:
          # ocaml-system = "4.14.0";
          ## - or force ocamlfind to be a certain version:
          # ocamlfind = "1.9.2";
          # sexplib = "*";
        };
      scope = on.buildOpamProject' {} ./. query;
      overlay = final: prev: {
        # You can add overrides here
        ${package} = prev.${package}.overrideAttrs (_: {
          # Prevent the ocaml dependencies from leaking into dependent environments
          doNixSupport = false;
        });
      };
      scope' = scope.overrideScope overlay;
      default = scope'.${package};
      # Packages from devPackagesQuery
      devPackages =
        builtins.attrValues
        (pkgs.lib.getAttrs (builtins.attrNames devPackagesQuery) scope');
      # Packages in this workspace
      packages =
        (pkgs.lib.getAttrs (builtins.attrNames localPackagesQuery) scope') // {inherit default;};
    in {
      formatter = pkgs.alejandra;
      legacyPackages = scope';

      inherit packages;

      devShells.default = pkgs.mkShell {
        inputsFrom = builtins.attrValues packages;
        buildInputs =
          devPackages
          ++ [
            # You can add packages from nixpkgs here
          ];
      };
    });
}
