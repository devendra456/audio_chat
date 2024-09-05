## 0.0.1

* TODO: Describe initial release.

### Changed
- **Vibrator Library**: Replaced the existing vibrator library with a new version to improve performance and reliability.

### Added
- **Permission Requirement**: Added a requirement for users to include the `VIBRATE` permission in the `AndroidManifest.xml` file. To use the vibrator functionality, please add the following line:
  ```xml
  <uses-permission android:name="android.permission.VIBRATE" />