// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:object_recognition/features/detection_feature/data/data_sources/tflite/image_classification_helper.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final imageClassificationHelper = ImageClassificationHelper();
  Map<String, double>? classification;
  bool isProcessing = false;
  CameraBloc() : super(const CameraState(classificationObj: [])) {
    /// start on [cameraPage]
    on<StartDetect>((event, emit) {
      final camearaController = event.cameraController;
      imageClassificationHelper.initHelper().whenComplete(() {
        /// start creating a stream of camera frames
        camearaController.startImageStream(imageAnalysis);
      });
    });
  }

  /// [analysis] of camera frames by [ImageClassificationHelper] class
  Future<void> imageAnalysis(CameraImage cameraImage) async {
    if (isProcessing) {
      return;
    }
    isProcessing = true;
    classification =
        await imageClassificationHelper.inferenceCameraFrame(cameraImage);
    final objList = classification!.entries.toList()
      ..sort(
        (a, b) => a.value.compareTo(b.value),
      )
      ..reversed.toList();
    emit(state.copyWith(newClassificationObj: objList.take(3).toList()));
    isProcessing = false;
  }

  void dispose() {
    imageClassificationHelper.close();
  }
}
