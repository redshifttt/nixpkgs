{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, python3Packages
, ronn
, shellcheck
}:

buildGoModule rec {
  pname = "actionlint";
  version = "1.6.10";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    sha256 = "sha256-RFsNJiCeSAeEWOUnfBpeIZKoS2mlXazYMQd1M6yFLGU=";
  };

  vendorSha256 = "sha256-CxNER8aQftMG14M+x6bPwcXgUZRkUDYZtFg1cPxxg+I=";

  nativeBuildInputs = [ makeWrapper ronn installShellFiles ];

  postInstall = ''
    ronn --roff man/actionlint.1.ronn
    installManPage man/actionlint.1
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${lib.makeBinPath [ python3Packages.pyflakes shellcheck ]}
  '';

  ldflags = [ "-s" "-w" "-X github.com/rhysd/actionlint.version=${version}" ];

  meta = with lib; {
    homepage = "https://rhysd.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/rhysd/actionlint/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "actionlint";
  };
}
