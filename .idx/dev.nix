{pkgs}: {
  channel = "stable-24.05";
  packages = [
    pkgs.jdk17
    pkgs.unzip
    pkgs.google-cloud-sdk
    pkgs.flutter
    pkgs.apt
    pkgs.cmake
  ];
  idx.extensions = [
    "Dart-Code.dart-code"
    "Dart-Code.flutter"
  ];
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "flutter";
      };
    };
  };
}