{ lib, fetchurl, perlPackages, makeWrapper, gnupg, re2c, gcc, gnumake }:

perlPackages.buildPerlPackage rec {
  pname = "SpamAssassin";
  version = "3.4.6";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${pname}-${version}.tar.bz2";
    sha256 = "044ng2aazqy8g0m17q0a4939ck1ca4x230q2q7q7jndvwkrpaj5w";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (with perlPackages; [
    HTMLParser NetCIDRLite NetDNS NetAddrIP DBFile HTTPDate MailDKIM LWP
    IOSocketSSL DBI EncodeDetect IPCountry NetIdent Razor2ClientAgent MailSPF
    NetDNSResolverProgrammable Socket6
  ]);

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = [ "PERL_BIN=${perlPackages.perl}/bin/perl" "PERL_TAINT=no" ];

  makeMakerFlags = [ "SYSCONFDIR=/etc LOCALSTATEDIR=/var/lib/spamassassin" ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/spamassassin
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB" --prefix PATH : ${lib.makeBinPath [ gnupg re2c gcc gnumake ]}
    done
  '';

  meta = {
    homepage = "http://spamassassin.apache.org/";
    description = "Open-Source Spam Filter";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qknight qyliss ];
  };
}
