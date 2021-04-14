# image_picker and image_cropper

Image picker  & image cropper and cupertinosheet


## Screenshots
<img src="ss1.png" height="300" /> <img src="ss2.png" height="300" /> <img src="ss3.png" height="300" /><img src="ss4.png" height="300" /> 

## dependencies:


```yaml
  dependencies:
    flutter:
      sdk: flutter
    image_picker: ^0.7.4
    image_cropper: ^1.4.0
```

## How to use
```dart
   Future _selectPhoto(index) async {
    final file = await Utils.pickMedia(
      isGallery: isGallery,
      cropImage: cropSquareImage,
    );
    if (file == null) return;
    if (imageFiles.length < 3)
      setState(() => imageFiles.add(file));
    else
      setState(() {
        imageFiles.removeAt(index);
        imageFiles.insert(index, file);
      });
  }

  Future<File> cropSquareImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 0.5, ratioY: .5),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.png,
      androidUiSettings: androidUiSettingsLock(),
      iosUiSettings: iosUiSettingsLock(),
    );
  }

  IOSUiSettings iosUiSettingsLock() {
    return IOSUiSettings(
      aspectRatioLockEnabled: true,
      rotateButtonsHidden: false,
      rectX: 1.0,
      rectY: 1.0,
      rotateClockwiseButtonHidden: false,
    );
  }
```
### Android  path => android/app/src/main/AndroidManifest.xml
 

```activity
   <activity
      android:name="com.yalantis.ucrop.UCropActivity"
      android:screenOrientation="portrait"
      android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

### IOS   path => ios/Runner/Info.plist

```keys
    <key>NSCameraUsageDescription</key>
    <string>Explanation on why the camera access is needed.</string>	
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Privacy - Photo Library Usage Description</string>	
    <key>NSMicrophoneUsageDescription</key>
    <string>Privacy - Microphone Usage Description</string>
```
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
