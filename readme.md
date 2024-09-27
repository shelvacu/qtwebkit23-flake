# qtwebkit 2.3.4 flake

This is a flake that builds qtwebkit 2.3.4 (the last version that supported Qt4). It requires nixpkgs 22.05 because 22.11 removed Qt4.

Note that qtwebkit 2.3.4 is very old, unmaintained, and has many known security vulnerabilities. It should not be pointed at the public internet.

## How to use

Build directly:

`nix build github:shelvacu/qtwebkit23-flake`

Add as overlay:

```nix
{
  # Qt4 was removed in 22.11
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.qtwebkit23 = {
    url = "github:shelvacu/qtwebkit23-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # ...
}
# in nixos config
{ inputs, ...}: {
  nixpkgs.overlays = [ inputs.qtwebkit23.overlays.default ];
}
```

## License

This work is partially derived from [fedora's build package](https://src.fedoraproject.org/rpms/qtwebkit/blob/rawhide/f/qtwebkit.spec) and depends on nixpkgs, Qt, WebKit, and other projects which each have their own license.

All .patch files are from fedora.

Otherwise, <p xmlns:cc="http://creativecommons.org/ns#" >This work is marked with <a href="https://creativecommons.org/publicdomain/zero/1.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC0 1.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/zero.svg?ref=chooser-v1" alt=""></a></p>
