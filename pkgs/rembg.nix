{
  pkgs,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages; let
  gradio' = gradio.overrideAttrs (old: rec {
    disabledTests =
      [
        "test_component_example_values"
        "test_public_request_pass"
        "test_private_request_fail"
        "test_theme_builder_launches"
      ]
      ++ old.disabledTests;
  });
  asyncer = buildPythonPackage rec {
    pname = "asyncer";
    version = "0.0.8"; # Replace with the correct version
    pyproject = true;
    build-system = [pdm-backend];
    src = fetchFromGitHub {
      owner = "fastapi";
      repo = pname;
      rev = version;
      hash = "sha256-SbByOiTYzp+G+SvsDqXOQBAG6nigtBXiQmfGgfKRqvM=";
    };

    dependencies = [
      anyio
      typing-extensions
    ];
  };
in
  buildPythonApplication rec {
    pname = "rembg";
    version = "v2.0.61";

    propagatedBuildInputs = [
      jsonschema
      numpy
      onnxruntime
      opencv4 # <-- problematic dependency
      pillow
      pooch
      pymatting
      scikit-image
      scipy
      tqdm
      # pip
      aiohttp
      asyncer
      click
      fastapi
      filetype
      gradio'
      python-multipart
      uvicorn
      watchdog
    ];

    src = fetchFromGitHub {
      owner = "danielgatis";
      repo = pname;
      rev = version;
      hash = "sha256-VKPiQKV74D1OtMXsGJGfv91ffWyPzsrhM7wveQs3yrQ=";
    };
  }
