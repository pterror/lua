with import <nixpkgs> { };
mkShell rec {
  nativeBuildInputs = [
    luajit
    python3
  ];
  buildInputs = [
    wayland # compositor
    wlroots # compositor
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
  '';
}
