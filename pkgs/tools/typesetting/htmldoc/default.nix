{ lib, stdenv, fetchFromGitHub, zlib, libpng, libjpeg, SystemConfiguration, Foundation, pkg-config }:

stdenv.mkDerivation rec {
  pname = "htmldoc";
  version = "1.9.13";
  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "htmldoc";
    rev = "v${version}";
    sha256 = "sha256-wAqH3BKNYbOXMbnaRhz4QZ/49stxC2Qf+yatKBv0i68=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib libpng libjpeg ]
    ++ lib.optionals stdenv.isDarwin [ Foundation SystemConfiguration ];

  meta = with lib; {
    description = "Converts HTML files to PostScript and PDF";
    homepage    = "https://michaelrsweet.github.io/htmldoc";
    changelog   = "https://github.com/michaelrsweet/htmldoc/releases/tag/v${version}";
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ shanemikel ];
    platforms   = platforms.unix;

    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
  };
}
