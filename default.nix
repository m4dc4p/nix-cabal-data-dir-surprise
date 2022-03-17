let
  pkgs = import <nixpkgs> {};
  haskell = pkgs.haskell;
  callCabal2nix = pkgs.haskellPackages.callCabal2nix;
  library = (callCabal2nix "library" ./library {});
  app = haskell.lib.justStaticExecutables (callCabal2nix "app" ./app { inherit library; });
  big-app = haskell.lib.appendBuildFlag app "--ghc-option=-DINCLUDE_PATHS";
  docker-app = pkgs.dockerTools.buildImage {
    name = "docker-app";
    contents = [ app ];
  };
  docker-big-app = pkgs.dockerTools.buildImage {
    name = "docker-big-app";
    contents = [ big-app ];
  };
in {
  inherit app big-app docker-app docker-big-app;
}  
