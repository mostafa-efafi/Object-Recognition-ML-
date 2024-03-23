import 'package:flutter_test/flutter_test.dart';
import 'package:object_recognition/core/params/inference_model.dart';

void main() {
  group('isCameraFrame method', () {
    test('should be return false', () async {
      // arrange
      // act
      final model = InferenceModel(
        null,
        null,
        0,
        [''],
        [0],
        [0],
      );
      // assert
      expect(model.isCameraFrame(), isA<bool>());
      expect(model.isCameraFrame(), false);
    });
  });
}
