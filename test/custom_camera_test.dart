import 'package:custom_camera/camera_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('camera_model 常量', () {
    test('cameraTypeImage', () {
      expect(cameraTypeImage, 1);
    });
    test('cameraTypeVideo', () {
      expect(cameraTypeVideo, 2);
    });
    test('cameraTypeAll', () {
      expect(cameraTypeAll, 3);
    });
    test('faceTypeBack faceTypeFront', () {
      expect(faceTypeBack, 1);
      expect(faceTypeFront, 2);
    });
  });

  group('CameraModel', () {
    test('fromJson', () {
      final m = CameraModel.fromJson({
        'width': 1920,
        'height': 1080,
        'type': 2,
        'flash_type': 1,
        'face_type': 1,
        'origin_file_path': '/path/to/file',
        'thumbnail_file_path': '/path/to/thumb',
        'duration': 30,
      });
      expect(m.width, 1920);
      expect(m.height, 1080);
      expect(m.type, 2);
      expect(m.originFilePath, '/path/to/file');
      expect(m.duration, 30);
    });

    test('fromJson 无 duration', () {
      final m = CameraModel.fromJson({
        'width': 800,
        'height': 600,
        'type': 1,
        'origin_file_path': '',
        'thumbnail_file_path': '',
      });
      expect(m.duration, isNull);
    });
  });
}
