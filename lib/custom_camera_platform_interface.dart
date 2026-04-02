import 'camera_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'custom_camera_method_channel.dart';

abstract class CustomCameraPlatform extends PlatformInterface {
  /// Constructs a CustomCameraPlatform.
  CustomCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static CustomCameraPlatform _instance = MethodChannelCustomCamera();

  /// The default instance of [CustomCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelCustomCamera].
  static CustomCameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CustomCameraPlatform] when
  /// they register themselves.
  static set instance(CustomCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<CameraModel?> pickCamera(
      {int sourceType = cameraTypeAll,
      int faceType = faceTypeBack,
      int animated = 1,
      int appType = 0,
      int flashType = 0,
      String themeColor = '#FF92C6'}) {
    throw UnimplementedError('pickCamera() has not been implemented.');
  }

  Future<void> destory() {
    throw UnimplementedError('destory() has not been implemented.');
  }
}
