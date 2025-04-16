/* Usage example in flake.nix:

   {
     inputs = {
       home-manager.url = "github:nix-community/home-manager";
       nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
     };

     outputs = {
       self,
       nixpkgs,
       home-manager,
       nix-doom-emacs,
       ...
     }: {
       nixosConfigurations.exampleHost = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           home-manager.nixosModules.home-manager
           {
             home-manager.users.exampleUser = { pkgs, ... }: {
               imports = [ nix-doom-emacs.hmModule ];
               home.doom-emacs = {
                 enable = true;
                 doomPrivateDir = ./path/to/doom.d;
               };
             };
           }
         ];
       };
     };
   }
*/

{
  description = "nix-doom-emacs home-manager module";

  inputs = {
    # TODO: change back to master once we get synced back with upstream changes
    doom-emacs.url = "github:doomemacs/doomemacs/3853dff5e11655e858d0bfae64b70cb12ef685ac";
    doom-emacs.flake = false;
    doom-snippets.url = "github:doomemacs/snippets";
    doom-snippets.flake = false;
    emacs-overlay.url = "github:nix-community/emacs-overlay/c16be6de78ea878aedd0292aa5d4a1ee0a5da501";
    emacs-overlay.flake = false;
    emacs-so-long.url = "github:hlissner/emacs-so-long";
    emacs-so-long.flake = false;
    evil-escape.url = "github:hlissner/evil-escape";
    evil-escape.flake = false;
    evil-markdown.url = "github:Somelauw/evil-markdown";
    evil-markdown.flake = false;
    evil-org-mode.url = "github:hlissner/evil-org-mode";
    evil-org-mode.flake = false;
    evil-quick-diff.url = "github:rgrinberg/evil-quick-diff";
    evil-quick-diff.flake = false;
    explain-pause-mode.url = "github:lastquestion/explain-pause-mode";
    explain-pause-mode.flake = false;
    format-all.url = "github:lassik/emacs-format-all-the-code/47d862d40a088ca089c92cd393c6dca4628f87d3";
    format-all.flake = false;
    nix-straight.url = "github:nix-community/nix-straight.el";
    nix-straight.flake = false;
    nose.url = "github:emacsattic/nose";
    nose.flake = false;
    ob-racket.url = "github:xchrishawk/ob-racket";
    ob-racket.flake = false;
    org-contrib.url = "path:./org-contrib-fork";
    org-contrib.flake = false;
    org-yt.url = "github:TobiasZawada/org-yt";
    org-yt.flake = false;
    org.url = "github:emacs-straight/org-mode";
    org.flake = false;
    php-extras.url = "github:arnested/php-extras";
    php-extras.flake = false;
    revealjs.url = "github:hakimel/reveal.js";
    revealjs.flake = false;
    rotate-text.url = "github:debug-ito/rotate-text.el";
    rotate-text.flake = false;
    sln-mode.url = "github:sensorflo/sln-mode";
    sln-mode.flake = false;
    ts-fold.url = "github:jcs-elpa/ts-fold";
    ts-fold.flake = false;
    ws-butler.url = "github:hlissner/ws-butler";
    ws-butler.flake = false;
    vterm.url = "github:akermu/emacs-libvterm";
    vterm.flake = false;
    consult.url = "github:minad/consult/c3608b1f634aebf8770ecb1d933a1ae9c34ecdf8";
    consult.flake = false;
    org-ai.url = "github:rksm/org-ai";
    org-ai.flake = false;
    gptel.url = "github:karthink/gptel";
    gptel.flake = false;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let inherit (flake-utils.lib) eachDefaultSystem mkApp;
    in eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        apps = {
          default = self.outputs.apps.${system}.doom-emacs-example;
          doom-emacs-example = mkApp {
            drv = self.outputs.packages.${system}.doom-emacs-example;
            exePath = "/bin/emacs";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            [ (pkgs.python3.withPackages (ps: with ps; [ PyGithub ])) ];
        };

        package = { ... }@args:
          pkgs.lib.warn ''
            nix-doom-emacs no longer supports the deprecated `package` flake output.
            It will be removed after the release of NixOS 23.05.

            Please use `packages.${system}.default.override { ... }` instead!
          ''
          (pkgs.callPackage self args);

        packages = {
          default = self.outputs.packages.${system}.doom-emacs-example;
          doom-emacs-example = pkgs.callPackage self {
            doomPrivateDir = ./test/doom.d;
          };
        };
        checks = import ./checks.nix { inherit system; } inputs;
      }) // {
        hmModule = import ./modules/home-manager.nix inputs;
      };
}

  #
