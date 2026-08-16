{
  description = "plottool - send HPGL files to a serial HPGL plotter/cutter";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs:
        let
          pythonEnv = pkgs.python3.withPackages (ps: with ps; [
            pyserial
            numpy
            wxpython
          ]);

          plottool = pkgs.stdenv.mkDerivation {
            pname = "plottool";
            version = "0.1.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/plottool $out/bin
              install -m644 hpgl.py hpglpreview.py $out/share/plottool/
              install -m644 plottool.py $out/share/plottool/

              makeWrapper ${pythonEnv}/bin/python3 $out/bin/plottool \
                --add-flags $out/share/plottool/plottool.py

              makeWrapper ${pythonEnv}/bin/python3 $out/bin/hpglpreview \
                --add-flags $out/share/plottool/hpglpreview.py

              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Send HPGL files to a plotter/cutter over a serial port";
              homepage = "https://github.com/Stratum0/plottool";
              license = licenses.gpl3Plus;
              platforms = platforms.unix;
              mainProgram = "plottool";
            };
          };
        in
        {
          inherit plottool;
          default = plottool;
        });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.plottool}/bin/plottool";
        };
        hpglpreview = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.plottool}/bin/hpglpreview";
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            (pkgs.python3.withPackages (ps: with ps; [ pyserial numpy wxpython ]))
          ];
        };
      });
    };
}
