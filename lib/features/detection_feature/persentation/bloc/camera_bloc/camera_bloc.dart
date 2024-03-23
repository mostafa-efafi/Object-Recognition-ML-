import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraController? cameraController;
  CameraBloc({this.cameraController}) : super(CameraInitial()) {
    on<CameraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  void dispose(){
    
  }
}
