final: _: let
  writeShellApp = args: let
    pname = args.name;
    src = args.src or (./. + "/${args.name}.sh");
    solutions = final.lib.filterAttrs (n: _: n != "name" && n != "src") args;
  in
    final.resholve.mkDerivation {
      inherit pname src;
      version = "0.0.0";

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp $src $out/bin/${args.name}
        runHook postInstall
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck
        ${final.stdenv.shellDryRun} "$out/bin/${args.name}"
        ${final.shellcheck}/bin/shellcheck "$out/bin/${args.name}"
        ${final.shfmt}/bin/shfmt --diff -s -ln bash -i 0 -ci "$out/bin/${args.name}"
        runHook postInstallCheck
      '';

      solutions.default =
        {
          interpreter = "${final.bash}/bin/bash";
          scripts = ["bin/${args.name}"];
        }
        // solutions;
    };
in {
  testhello = writeShellApp {
    name = "testhello";
    inputs = with final; [];
  };
}
