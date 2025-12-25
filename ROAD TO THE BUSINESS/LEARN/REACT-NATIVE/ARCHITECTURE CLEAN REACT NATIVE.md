## Get started

`npm uninstall -g react-native-cli @react-native-community/cli`

`npx @react-native-community/cli@latest init *nameProject*`

```bash
brew install node
brew install watchman
```

```bash
brew install --cask zulu@17

# Get path to where cask was installed to find the JDK installer
brew info --cask zulu@17

# ==> zulu@17: <version number>
# https://www.azul.com/downloads/
# Installed
# /opt/homebrew/Caskroom/zulu@17/<version number> (185.8MB) (note that the path is /usr/local/Caskroom on non-Apple Silicon Macs)
# Installed using the formulae.brew.sh API on 2024-06-06 at 10:00:00

# Navigate to the folder
open /opt/homebrew/Caskroom/zulu@17/<version number> # or /usr/local/Caskroom/zulu@17/<version number>
```

`export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home`

```bash
npm install react-native-mmkv react-native-nitro-modules
cd ios && pod install

npm install @reatom/core @reatom/react
```

>If you are having trouble with iOS, try to reinstall the dependencies by running:

1. `cd ios` to navigate to the `ios` folder.
2. `bundle install` to install [Bundler](https://bundler.io/)
3. `bundle exec pod install` to install the iOS dependencies managed by CocoaPods.

`yarn start`


[[REACT NATIVE ARCHITECTURE PATTERNS]]

