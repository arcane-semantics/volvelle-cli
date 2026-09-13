{
  rev,
  lib,
  python3,
  installShellFiles,
  swappy,
  libnotify,
  slurp,
  wl-clipboard,
  cliphist,
  xdg-utils,
  dart-sass,
  grim,
  fuzzel,
  gpu-screen-recorder,
  dconf,
  killall,
  volvelle-shell,
  withShell ? false,
  discordBin ? "discord",
  qtctStyle ? "Darkly",
}:
python3.pkgs.buildPythonApplication {
  pname = "volvelle-cli";
  version = "${rev}";
  src = ./.;
  pyproject = true;

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    materialyoucolor
    pillow
  ];

  pythonImportsCheck = ["volvelle"];

  nativeBuildInputs = [installShellFiles];
  propagatedBuildInputs =
    [
      swappy
      libnotify
      slurp
      wl-clipboard
      cliphist
      xdg-utils
      dart-sass
      grim
      fuzzel
      gpu-screen-recorder
      dconf
      killall
    ]
    ++ lib.optional withShell volvelle-shell;

  SETUPTOOLS_SCM_PRETEND_VERSION = 1;

  patchPhase = ''
    # Replace qs config call with nix shell pkg bin
    substituteInPlace src/volvelle/subcommands/shell.py \
    	--replace-fail '"qs", "-c", "volvelle"' '"volvelle-shell"'
    substituteInPlace src/volvelle/subcommands/screenshot.py \
    	--replace-fail '"qs", "-c", "volvelle"' '"volvelle-shell"'

    # Use config bin instead of discord + fix todoist
    substituteInPlace src/volvelle/subcommands/toggle.py \
    	--replace-fail 'discord' ${discordBin} \
      --replace-fail '["todoist"]' '["todoist.desktop"]'

    # Use config style instead of darkly
    substituteInPlace src/volvelle/data/templates/qtengine.json \
    	--replace-fail 'Darkly' '${qtctStyle}'
  '';

  postInstall = "installShellCompletion completions/volvelle.fish";

  meta = {
    description = "Command-line interface for Volvelle";
    homepage = "https://github.com/arcane-semantics/volvelle-cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "volvelle";
    platforms = lib.platforms.linux;
  };
}
