import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_recognition/config/languages/fa.dart';
import 'package:object_recognition/features/detection_feature/persentation/bloc/camera_bloc/camera_bloc.dart';
import 'package:object_recognition/features/detection_feature/persentation/widgets/list_of_names.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController cameraController;
  List<CameraDescription> allCameras = [];
  late CameraBloc bloc;
  String _error = '';

  Future<bool> _getCameras() async {
    // / get camera and wait for android 13
    bool camerasAvailable = false;
    List<CameraDescription> cameras = [];

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        camerasAvailable = true;
        timer.cancel();
      }
    });

    while (!camerasAvailable) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    allCameras = cameras;
    return _initCamera();
  }

  bool _initCamera() {
    /// get first [back] camera
    final rearCamera = allCameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
        orElse: () => allCameras.first);
    cameraController = CameraController(
      rearCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420,
    );
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _error = e.toString();
            break;
          default:
            _error = e.toString();
            break;
        }
      }
    });
    return true;
  }

  @override
  void initState() {
    _getCameras();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            Fa.appBarTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Builder(builder: (bContext) {
          try {
            if (cameraController.value.isInitialized) {
              BlocProvider.of<CameraBloc>(bContext)
                  .add(StartDetect(cameraController));
              return Center(child: CameraPreview(cameraController));
            }
          } catch (e) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(child: Text(_error));
        }),

        /// a list of [detected] [objects]
        bottomSheet: const ListOfNames(),
      ),
    );
  }
}
