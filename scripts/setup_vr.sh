mkdir -p deps/
V=v0.17.1
NAME=lovr
if [ "$(uname -s)" = "Linux" ]
then
	F=lovr-$V-x86_64.AppImage
	if [ ! -f deps/$F ]
	then
		curl -L https://github.com/bjornbytes/lovr/releases/download/$V/$F -o deps/$F
		uname -v | grep NixOS >/dev/null 2>&1
		if [ "$?" -eq 0 ]
		then
			cat <<END > deps/$NAME
#!/deps/sh
nix run nixpkgs#appimage-run $(dirname $(realpath "$0"))/deps/$F \$@
END
			chmod +x deps/$NAME
		else
			chmod +x deps/$F
			ln -s ./$F deps/$NAME
		fi
	fi
else
	# assume macos
	curl -L https://github.com/bjornbytes/lovr/releases/download/$V/lovr-$V.app.zip -o deps/
	# TODO
fi
