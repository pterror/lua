with import <nixpkgs> { };
mkShell rec {
  nativeBuildInputs = [
    luajit
    python3
    cmake
  ];
  buildInputs = [
    libxkbcommon # compositor
    wayland # compositor
    wlroots_0_18 # compositor
    #pixman # wlroots
    #libinput # wlroots
    #libGL # wlroots, gles2 backend
    #vulkan-headers # wlroots, vulkan backend
    #xorg.libxcb # wlroots
    #xorg.xcbutilwm # wlroots (xcb_ewmh)
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
    export WLR_DIR="${pkgs.wlroots}/include/wlroots-0.18/"
  '';
}
