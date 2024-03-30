import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_recognition/config/languages/fa.dart';
import 'package:object_recognition/features/detection_feature/persentation/bloc/camera_bloc/camera_bloc.dart';

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

  Future<bool> getCameras() async {
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
    final rearCamera = allCameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
        orElse: () => allCameras.first);
    cameraController = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
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
    getCameras();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Fa.appBarTitle),
      ),
      body: Builder(builder: (context) {
        try {
          if (cameraController.value.isInitialized) {
            return CameraPreview(cameraController);
          }
        } catch (e) {
          return const Center(child: CircularProgressIndicator());
        }
        return  Center(child: Text(_error));
      }),
    );
  }
}
