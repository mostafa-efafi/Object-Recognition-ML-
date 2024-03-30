part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {}

class StartDetect extends CameraEvent {
  final CameraController cameraController;
  StartDetect(this.cameraController);
  @override
  List<Object?> get props => [cameraController];
}
