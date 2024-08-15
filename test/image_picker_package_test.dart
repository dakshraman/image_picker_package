import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_package/image_picker_service.dart';

void main() {
  test('ImageSource enum should have correct values', () {
    expect(ImageSource.camera.index, 0);
    expect(ImageSource.gallery.index, 1);
  });

  // Add more tests related to your service here
}
