{
  description = "Flake for react native + rust";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    android.url = "github:tadfisher/android-nixpkgs";
    android.inputs.nixpkgs.follows = "nixpkgs";

    rust.url = "github:oxalica/rust-overlay";
    rust.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    {
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend rust.overlays.default;
        rust-pkg = pkgs.rust-bin.selectLatestNightlyWith (
          toolchain:
          toolchain.default.override {
            extensions = [
              "rust-analyzer"
              "rust-src"
            ];
            targets = [
              "aarch64-linux-android"
              "armv7-linux-androideabi"
              "i686-linux-android"
              "x86_64-linux-android"
            ];
          }
        );

        android-sdk = inputs.android.sdk.${system} (
          sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            cmake-3-22-1
            build-tools-34-0-0
            build-tools-35-0-0
            platform-tools
            platforms-android-35
            emulator
            system-images-android-35-google-apis-x86-64
            ndk-26-1-10909125
          ]
        );

        java-jdk = pkgs.jdk17;

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      in
      {
        formatter = treefmtEval.config.build.wrapper;
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
        packages.createAndEmulateExpoApp = pkgs.writeScriptBin "create-and-emulate-expo-app" ''
          #!/usr/bin/env sh
          date=$(date +%s)
          avd=myavd$date
          echo "using date $date"
          mkdir -p demo-app-$date/avds
          export ANDROID_AVD_HOME=$HOME/.config/.android/avd
          echo using $ANDROID_AVD_HOME as ANDROID_AVD_HOME
          echo "no" | avdmanager create avd -k 'system-images;android-35;google_apis;x86_64' -n $avd
          cd demo-app-$date
          echo "demo-app" | yarn create expo-app
          cd demo-app
          yarn expo install expo-dev-client
          yarn expo run:android -d $avd
        '';

        packages.default = self.packages.${system}.createAndEmulateExpoApp;
        devShells.default = pkgs.mkShell (rec {

          packages =
            [
              self.packages.${system}.createAndEmulateExpoApp
              android-sdk
              rust-pkg
              java-jdk
            ]
            ++ (with pkgs; [
              nodejs_18
              yarn
              watchman
              aapt
              cargo-ndk
            ]);

          JAVA_HOME = java-jdk.home;
          ANDROID_HOME = "${android-sdk}/share/android-sdk";
          ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/34.0.0/aapt2";
          ANDROID_AVD_HOME = "~/.config/.android/avd";
        });
      }
    );
}
