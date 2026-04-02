import 'camera_model.dart';

import 'custom_camera_platform_interface.dart';

class CustomCamera {
  Future<String?> getPlatformVersion() {
    return CustomCameraPlatform.instance.getPlatformVersion();
  }

  Future<CameraModel?> pickCamera(
      {int sourceType = cameraTypeAll,
      int faceType = faceTypeBack,
      int animated = 1,
      int flashType = 0,
      int appType = 0,
      String themeColor = '#FF92C6'}) {
    return CustomCameraPlatform.instance.pickCamera(
        sourceType: sourceType,
        faceType: faceType,
        animated: animated,
        appType: appType,
        flashType: flashType,
        themeColor: themeColor);
  }

  Future<void> destory() {
    return CustomCameraPlatform.instance.destory();
  }
}
