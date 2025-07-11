{
  description = "A simple Go package";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        rec {

          gif-infinite = pkgs.writeShellApplication {
              name = "show-gif";
              text = ''
                URL=$(${get-gif-url}/bin/get-gif-url "$1")
                ${pkgs.mpv}/bin/mpv --loop-file='inf' --no-osc --vo=tct --really-quiet "$URL"
              '';
            };

          default = pkgs.writeShellApplication {
              name = "show-gif";
              text = ''
                URL=$(${get-gif-url}/bin/get-gif-url "$1")
                ${pkgs.mpv}/bin/mpv --no-osc --vo=tct --really-quiet "$URL"
              '';
            };

          get-gif-url = pkgs.writers.writePython3Bin "get-gif-url" {
            flakeIgnore = [ "E501" ];
            libraries = with pkgs.python3Packages; [
              pyyaml
              requests
            ];
          } (builtins.readFile ./gif.py);
        }
      );

    };
}
