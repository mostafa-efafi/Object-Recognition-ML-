import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  Future<bool> getCameras() async {
    /// get camera and wait for android 13
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

  Future<bool> _initCamera() async {
    final rearCamera = allCameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
        orElse: () => allCameras.first);
    cameraController = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    cameraController.initialize().whenComplete(() {
      bloc = CameraBloc(
        cameraController: cameraController,
      );
    });
    return true;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(Fa.appBarTitle),
      // ),
      body: FutureBuilder<bool>(
          future: getCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return CameraPreview(cameraController);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
