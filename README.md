# audio_chat

`audio_chat` is a Flutter package that provides robust functionality for voice chatting, similar to WhatsApp. With `audio_chat`, you can effortlessly integrate real-time voice communication into your Flutter applications, enabling seamless and interactive user experiences.

## Features

- **Real-Time Voice Communication:** Enable high-quality, low-latency voice chat between users.
- **Cross-Platform Support:** Works seamlessly on both iOS and Android devices.
- **Customizable UI:** Adjust and style the user interface components to fit your app’s design.
- **Push-to-Talk:** Option to implement a push-to-talk feature for controlled communication.
- **Noise Suppression:** Built-in noise suppression to ensure clear audio.
- **Automatic Gain Control:** Adjusts audio levels automatically for balanced sound.

## Installation

Add the `audio_chat` package to your `pubspec.yaml` file:

```yaml
dependencies:
  audio_chat: ^1.0.0

- **Permission Requirement**: Added a requirement for users to include the `VIBRATE` permission in the `AndroidManifest.xml` file. To use the vibrator functionality, please add the following line:
  ```xml
  <uses-permission android:name="android.permission.VIBRATE" />