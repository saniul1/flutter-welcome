# Setup

## Project Setup

- Change package name to your liking
  
  - For Android

    Modify the applicationId in your 'build.gradle' file inside your `android/app` directory.

    ```java
      defaultConfig {
        applicationId "your.package.name" // change this
      ...
      }
    ```

  - For iOS

    Change the bundle identifier from your `Info.plist` file inside your `ios/Runner` directory.

     ```plist
        <key>CFBundleIdentifier</key>
        <string>com.your.packagename</string>
     ```
  
- Change minimum SDK to 21 or higher in your 'build.gradle' file inside your `android/app` directory.
  
  ```java
    defaultConfig {
      minSdkVersion 21 // this line >= 21
    }
  ```

- For Authentication service to work you need to add a SHA1 certificate

  - To get a key you need have [JDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk13-downloads-5672538.html) installed.

    ***make sure jdk is added to  your `PATH` list in windows.***

    To get a debug certificate run:

    ```shell
      keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore #For windows

      keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore  #For Mac or Linux
    ```

    To get release certificate run:

    ```shell
      keytool -exportcert -list -v \
      -alias <your-key-name> -keystore <path-to-production-keystore>
    ```

## Firebase Setup

  Sign in to your [firebase console](https://console.firebase.google.com/).

  1. Create a project

  2. Give name and choose country/region according to your liking.

  3. Done.

  After you create your project, you have set up for different platform individually.

- For Android

  choose android from available option.

  - set Android package name to the name you set in your flutter project.

    To see what's your package name go to `android/app/src/main/AndroidManifest.xml`.

- For Ios

  choose ios from available option.

    1. go to the root directory of your Flutter app and open the command line tool.

    2. Run command: `open ios/Runner.xcworkspace`

    3. selelct Runner in the left panel and choose General tab on the right.

    4. Copy the Bundle Identifier and paste in `iOS bundle ID` in firebase.

  - in Debug signing certificate SHA-1

    copy the SH1 key printed in cmd console after followng the steps previeusly mentioned.

  - download the config file `google-services.json` in case of android  or `GoogleService-Info.plist` in case of ios

  ***you can safely skip all the other step.***

### Project Setup: Android

- copy the `google-services.json` you downloaded and put it in `android/app` folder.

- open `android/app/build.gradle` file.
     paste at the end of file:

```java
  apply plugin: 'com.google.gms.google-services'
```

- add a new dependency to `android/build.gradle`, inside buildscript tag.

```java
  buildscript {
   dependencies {
    // ...
    classpath 'com.google.gms:google-services:4.3.2'
  }
```

- make sure Google's Maven repository is included in both your `buildscript` and `allprojects`

  ```java
    buildscript {
      ...
      repositories {
        google()
        ...
      }
      dependencies {
        ...
      }
    }

    allprojects {
        repositories {
          google()
          ...
        }
    }
  ```

### Project Setup: ios

- copy the `GoogleService-Info.plist` you downloaded and put it in `ios/Runner` folder (i.e. - Do it by opening the project in Xcode for safety).

### Update dependencies in `pubspec.yaml` file

- Add this packages:
  
  ```yaml
    dependencies:
    flutter:
      sdk: flutter
    ...
    cloud_firestore: ^0.13.0+1

    firebase_core: ^0.4.0
    firebase_analytics: ^1.0.4
    firebase_auth:  ^0.6.6
    google_sign_in: ^3.2.4

    rxdart: 0.22.0 # optional
  ```

***Relaunch you app and your app should be properly configured with firebase.***
