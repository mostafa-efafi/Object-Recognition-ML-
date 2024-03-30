import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_recognition/features/detection_feature/persentation/bloc/camera_bloc/camera_bloc.dart';

class ListOfNames extends StatelessWidget {
  const ListOfNames({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        final list = state.classificationObj!
            .map((e) => Container(
                  decoration: BoxDecoration(
                      color: _colorGenerator(e),
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  margin:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: textStyle,
                      ),
                      Text('%${(e.value * 100).round()}', style: textStyle)
                    ],
                  ),
                ))
            .toList();
        return Container(
            color: Colors.grey.shade200,
            child: ListView(
              reverse: true,
              shrinkWrap: true,
              children: list,
            ));
      },
    );
  }

  Color _colorGenerator(MapEntry<String, double> e) {
    /// Created [label] [color] with detection [percentage] value 
    if (e.value > 0.9) {
      return Colors.green;
    } else if (e.value < 0.2) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
