{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    sha256 = "sha256-FCBNm51QI1jDdq2BZFwZA1kpIfXIvh1ickmY3ZqwGPY=";
  };

  cargoSha256 = "sha256-CBCyujJHWTatJO+Tk6MyOk12B0cY1JSwLQizjcXeQzQ=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
  };
}
