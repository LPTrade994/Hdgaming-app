# Hdgaming-app Repository

This repository contains the `hdgaming_app` Flutter project.

## Codemagic Setup

To build the mobile applications in CI you can use the following steps as a
Codemagic script. The script installs Flutter, generates the iOS and Android
platform folders if missing and performs a debug build for both targets:

```bash
# install Flutter if not already available
which flutter >/dev/null 2>&1 || {
  echo "Installing Flutter SDK"
  sudo apt-get update -y
  sudo apt-get install -y curl git unzip xz-utils libglu1-mesa
  curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_stable.tar.xz
  tar xf flutter_linux_stable.tar.xz
  export PATH="$PWD/flutter/bin:$PATH"
  echo 'export PATH="$PWD/flutter/bin:$PATH"' >>~/.bashrc
  flutter --version
}

cd hdgaming_app || exit 1

# create platform files when absent
if [ ! -d ios ] || [ ! -d android ]; then
  flutter create . --platforms=ios,android --org it.hdgaming \
    --project-name hdgaming_app --no-overwrite
fi

# apply minimal SDK compatibility tweaks
sed -i 's/platform :ios, .*$/platform :ios, "13.0"/' ios/Podfile
sed -i 's/compileSdkVersion.*/compileSdkVersion 34/' android/app/build.gradle
sed -i 's/minSdkVersion.*/minSdkVersion 21/' android/app/build.gradle
sed -i 's/targetSdkVersion.*/targetSdkVersion 34/' android/app/build.gradle

# fetch dependencies and run basic builds
flutter pub get
flutter build apk --debug
flutter build ios --debug --no-codesign
```

After the script finishes you can commit the generated platform files and push
the changes back to the repository.
