{ mkDerivation
, lib
, cmake
, extra-cmake-modules
, pkg-config
, SDL2
, qttools
, xorg
, fetchFromGitHub
, itstool
}:

mkDerivation rec {
  pname = "antimicrox";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = pname;
    rev = version;
    sha256 = "sha256-brG3DTpWRYmDemTeteuuNbF0JoDAXdcFwO12JC6/0/Q=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config itstool ];
  buildInputs = [
    SDL2
    qttools
    xorg.libXtst
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/lib/udev/rules.d/" "$out/lib/udev/rules.d/"
  '';

  meta = with lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 sbruder ];
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
  };
}
