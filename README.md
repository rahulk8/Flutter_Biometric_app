Please watch  this video for entire working of this Biometric app : https://drive.google.com/file/d/1lo7mtnLNoTPMWX8UPPSNMb_PA9lzysQy/view?usp=sharing

Here is Link to Download Flutter Biometric app APK : https://drive.google.com/file/d/1beflMk7iniu-Xfk5L3iwY3RyvJYu5WwK/view?usp=sharing

Fingerprint screen is blacked out due to android security system in the above video.

<img width="324" height="587" alt="image" src="https://github.com/user-attachments/assets/4a2f176a-6b77-4754-a8c1-bd31c9273211" />


<img width="333" height="482" alt="image" src="https://github.com/user-attachments/assets/81d2861c-a9c1-4c11-968e-d290ce34da3f" />

1. Project Features (Assignment Part 2a)


Hi, I’m going to walk you through my Flutter project called Biometric Login.

This app allows users to log in using fingerprint authentication. If that fails or if biometric is not available on the device, it automatically falls back to a PIN-based login.

It also stores authentication tokens securely using platform-specific secure storage. On Android, that’s the Keystore, and on iOS, it’s the Keychain.

The app handles important edge cases like when the device doesn’t support biometrics, or when the user disables biometric settings, or even when they add or remove fingerprints. 
In all these situations, the app gracefully shows appropriate messages and directs users to the right login method.

So overall, the app focuses on providing a secure login experience while keeping it smooth and user-friendly.




2. Technologies Used (Assignment Part 2b)

This project uses a few core Flutter packages to make everything work.

First, it uses the `local_auth` package to handle biometric authentication like fingerprints and face recognition.

Then, for storing sensitive login tokens, it uses `flutter_secure_storage`, which makes sure data is stored securely on the device.

To improve security further, it also uses `device_info_plus` to detect if the app is running on an emulator, which helps prevent spoofing or unauthorized access.

For the interface, I used basic Flutter widgets like snackbar for quick messages.



3. Tech Stack (Assignment Part 2c)

The frontend of this app is built entirely with Flutter using the Dart language.

For authentication, it uses biometrics through the local auth package and falls back to a PIN if biometrics are not available.

All sensitive data is saved using flutter secure storage, which makes use of native secure storage on Android and iOS.

The app supports both Android and iOS platforms.

On the security side, it includes spoofing detection using device info, limits PIN attempts, and checks for biometric changes to force reauthentication if needed.

