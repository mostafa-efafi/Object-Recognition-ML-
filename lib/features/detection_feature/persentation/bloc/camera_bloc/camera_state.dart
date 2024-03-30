part of 'camera_bloc.dart';

class CameraState extends Equatable {
  final List<MapEntry<String, double>>? classificationObj;
  const CameraState({this.classificationObj});

  CameraState copyWith({List<MapEntry<String, double>>? newClassificationObj}) {
    return CameraState(
        classificationObj: newClassificationObj ?? classificationObj);
  }

  @override
  List<Object?> get props => [classificationObj];
}
