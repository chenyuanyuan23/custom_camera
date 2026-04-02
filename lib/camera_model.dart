const int cameraTypeImage = 1;
const int cameraTypeVideo = 2;
const int cameraTypeAll = 3;

const int faceTypeBack = 1;
const int faceTypeFront = 2;

class CameraModel {
  int width = 0;
  int height = 0;
  int type = cameraTypeImage;
  String originFilePath = '';
  String thumbnailFilePath = '';
  int? duration;
  int? flashType = 0;
  int? faceType = faceTypeBack;

  CameraModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    type = json['type'];
    flashType = json['flash_type'];
    faceType = json['face_type'];
    originFilePath = json['origin_file_path'];
    thumbnailFilePath = json['thumbnail_file_path'];
    if (json.containsKey('duration')) {
      duration = json['duration'];
    }
  }
}
