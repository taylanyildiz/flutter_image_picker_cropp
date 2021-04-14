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
  enum SourceCode {
    gallery,
    camera,
  }

  class UtilsImage {
    static Future<File> imagePicker({
      @required SourceCode sourceCode,
      @required Future<File> Function(File file) croppImage,
    }) async {
      final source = sourceCode == SourceCode.gallery
          ? ImageSource.gallery
          : ImageSource.camera;
      final pickerImage = await ImagePicker().getImage(source: source);
      if (pickerImage == null) return null;
      if (croppImage == null)
        return File(pickerImage.path);
      else
        return croppImage(File(pickerImage.path));
    }
  }
```


```dart
    var imagesFile = <File>[];

  Future selectPhoto(index, sourceCode) async {
    final file = await UtilsImage.imagePicker(
      sourceCode: sourceCode,
      croppImage: croppImage,
    );
    if (file == null) return;
    if (imagesFile.length == (index + 1)) {
      imagesFile.removeAt(index);
      setState(() => imagesFile.insert(index, file));
    } else
      setState(() => imagesFile.add(file));
  }

  Future<File> croppImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 100,
      maxWidth: 100,
      compressFormat: ImageCompressFormat.png,
      androidUiSettings: androidUiSettingsLock(),
      iosUiSettings: iosUiSettings(),
    );
  }

  AndroidUiSettings androidUiSettingsLock() {
    return AndroidUiSettings(
      lockAspectRatio: false,
      toolbarTitle: 'Image Cropper',
      toolbarColor: Colors.orange,
      toolbarWidgetColor: Colors.white,
      activeControlsWidgetColor: Colors.white,
      hideBottomControls: true,
    );
  }

  IOSUiSettings iosUiSettings() {
    return IOSUiSettings(
      minimumAspectRatio: 1.0,
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
