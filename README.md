# image_picker and image_cropper

A new Project Flutter 


## Screenshots
<img src="ss1.png" height="300" /> <img src="ss2.png" height="300" /> <img src="ss3.png" height="300" /> <img src="ss4.png" height="300" />

## dependecies:
<br/>
  '''
  image_picker: ^0.7.4
  <br/>
  image_cropper: ^1.4.0
  <br/>
  '''
## Android
 path => android/app/src/main/AndroidManifest.xml
 <br/>
 copy this 
 <br/>
    '''
    <br/>
     <activity
        android:name="com.yalantis.ucrop.UCropActivity"
        <br/>
        android:screenOrientation="portrait"
        <br/>
        android:theme="@style/Theme.AppCompat.Light.NoActionBar"
        <br/>
      />
      <br/>
      paste in the path directory for ### image_picker
      <br/>
    '''
    <br/>
## IOS 
<br/>
path => ios/Runner/Info.plist
<br/>
copy this:
<br/>
'''
<br/>
<key>NSCameraUsageDescription</key>
<br/>
<string>Explanation on why the camera access is needed.</string>	<key>NSPhotoLibraryUsageDescription</key>
<br/>
<string>Privacy - Photo Library Usage Description</string>	<key>NSCameraUsageDescription</key>
<br/>
<string>Privacy - Camera Usage Description</string>
<br/>
<key>NSMicrophoneUsageDescription</key>
<br/>
<string>Privacy - Microphone Usage Description</string>
<br/>
'''
<br/>
paste in the path directory for ### image_cropper
<br/>
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
