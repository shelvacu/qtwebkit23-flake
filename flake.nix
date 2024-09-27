{
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  outputs = { nixpkgs, ... }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux = rec {
      qtwebkit23 = pkgs.callPackage ./qtwebkit.nix { };
      qtwebkit = qtwebkit23;
      default = qtwebkit23;
    };

    overlays.default = (final: prev: {
      qt48 = prev.qt48 // { qtwebkit = final.callPackage ./qtwebkit.nix { }; };
    });
  };
}
