{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-20.09";
    misoSrc.url = "https://github.com/dmjio/miso/archive/refs/tags/1.8.tar.gz";
    misoSrc.flake = false;
  };

  outputs = { self, nixpkgs, misoSrc, ... }:
    let
      pkgs = import nixpkgs { inherit system; overlays = []; };
      system = "x86_64-linux";
    in with misoSrc; {
      packages.${system}.default = pkgs.haskell.packages.ghcjs.callCabal2nix "app" ./. {};
    };
    # in with (import (builtins.fetchTarball {
    #     url = "https://github.com/dmjio/miso/archive/refs/tags/1.8.tar.gz";
    #   }) {}); {
    #   packages.${system}.default = pkgs.haskell.packages.ghcjs.callCabal2nix "app" ./. {};
    # };

}



# {
#   description = "miso";
#   inputs = {
#     haedosa.url = "github:haedosa/flakes";
#     nixpkgs.follows = "haedosa/nixpkgs";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs = {self, nixpkgs, flake-utils, ...}@inputs: {
#     overlays.default = nixpkgs.lib.composeManyExtensions
#       [(final: prev:
#         {
#           haskellPackages = prev.haskellPackages.extend
#             (hfinal: hprev: {
#               app = hfinal.callCabal2nix "app" ./. {};
#             });
#         }
#       )];
#   } // flake-utils.lib.eachSystem [ "x86_64-linux" ]
#     (system:
#     let
#       pkgs = import nixpkgs { inherit system; overlays = [self.overlays.default]; };
#     in {
#       packages = {
#         with (import (builtins.fetchTarball {
#           url = "https://github.com/dmjio/miso/archive/refs/tags/1.8.tar.gz";
#         }) {});
#         default = pkgs.haskell.packages.ghcjs.callCabal2nix "app" ./. {};
#       };


#       devShells = {
#         default = pkgs.haskellPackages.shellFor {
#           packages = p:[
#             p.cachix
#             p.app
#           ];
#         };
#       };


#     }
#   );
# }
# https://serokell.io/blog/gui-programming-talk
# https://www.youtube.com/watch?v=k1aq8ikO-8Q
