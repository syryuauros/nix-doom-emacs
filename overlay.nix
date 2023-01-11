{ self, ... }@inputs : final: prev: with final; {


  mk-doom-emacs = { extraPackages ? epkgs: [
      epkgs.org-roam
      epkgs.org-roam-ui
      epkgs.org-roam-timestamps
      # epkgs.org-roam-bibtex
  ]
                  , emacsPackage ? emacsNativeComp
                  , doomPrivateDir ? inputs.doom-private
                  , extraConfig ? ""
                  , emacsPackagesOverlay ? self: super: { }
                  }: callPackage self {
    emacsPackages = emacsPackagesFor emacsPackage;
    inherit extraPackages doomPrivateDir extraConfig emacsPackagesOverlay;
    dependencyOverrides = inputs;
  };

  doom-emacs = mk-doom-emacs {};

}
