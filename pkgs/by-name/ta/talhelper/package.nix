{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "talhelper";
  version = "3.0.30";

  src = fetchFromGitHub {
    owner = "budimanjojo";
    repo = "talhelper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-unKTwOkxi4MJO1YQpJCmwjmLBBtsH738KjI2jCudYqY=";
  };

  vendorHash = "sha256-f0Z+9lX/W13NpGhpS2Bu2I7ebLTTP5sXccL81zicqiQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/budimanjojo/talhelper/v3/cmd.version=v${finalAttrs.version}"
  ];

  subPackages = [
    "."
    "./cmd"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talhelper \
      --bash <($out/bin/talhelper completion bash) \
      --fish <($out/bin/talhelper completion fish) \
      --zsh <($out/bin/talhelper completion zsh)
  '';

  meta = {
    changelog = "https://github.com/budimanjojo/talhelper/releases/tag/v${finalAttrs.version}";
    description = "Help creating Talos kubernetes cluster";
    longDescription = ''
      Talhelper is a helper tool to help creating Talos Linux cluster
      in your GitOps repository.
    '';
    homepage = "https://github.com/budimanjojo/talhelper";
    mainProgram = "talhelper";
    maintainers = with lib.maintainers; [ madeddie ];
    license = lib.licenses.bsd3;
  };
})
