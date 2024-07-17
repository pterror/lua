with import <nixpkgs> { };
mkShell {
  nativeBuildInputs = [
    luajit
    python3
  ];
  buildInputs = [
  ];
}
