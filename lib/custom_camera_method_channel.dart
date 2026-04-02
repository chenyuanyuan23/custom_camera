import 'camera_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_camera_platform_interface.dart';

/// An implementation of [CustomCameraPlatform] that uses method channels.
class MethodChannelCustomCamera extends CustomCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_camera');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<CameraModel?> pickCamera(
      {int sourceType = cameraTypeAll,
      int faceType = faceTypeBack,
      int animated = 1,
      int appType = 0,
      int flashType = 0,
      String themeColor = '#FF92C6'}) async {
    Map? map = await methodChannel.invokeMethod('takePhotoAndVideo', {
      "source_type": sourceType,
      "face_type": faceType,
      'animated': animated,
      'appType': appType,
      'flashType': flashType,
      'theme_color': themeColor
    });
    if (map != null) {
      Map<String, dynamic> muMap = {};
      for (var key in map.keys) {
        muMap[key.toString()] = map[key];
      }
      return CameraModel.fromJson(muMap);
    }
    return null;
  }

  @override
  Future<void> destory() async {
    methodChannel.invokeMethod('destory');
  }
}
