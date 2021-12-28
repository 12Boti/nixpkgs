{ lib, stdenv, fetchurl, makeWrapper, jre_headless, runCommand, ktlint }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.43.2";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256-HXTkYwN6U8xyxgFnj69nLSpbDCqWUWeSuqlZbquRD6o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${jre_headless}/bin"
  '';

  passthru.tests = {
    format-file = runCommand "${pname}-format-file-test" { } ''
      mkdir -p $out
      f=$out/file.kt
      cat > $f << EOF
      fun main(args: Array<String>) {
        println("Hello, World!")
      }
      EOF
      ${ktlint}/bin/ktlint --format $f
    '';
  };

  meta = with lib; {
    description = "An anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ tadfisher SubhrajyotiSen ];
  };
}
