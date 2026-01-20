import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ZoomControls extends StatelessWidget {
  final TransformationController controller;

  const ZoomControls({super.key, required this.controller});

  void _zoomIn() {
    final matrix = controller.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      final zoomFactor = 1.2;
      final zoomedMatrix = matrix.clone()..scale(zoomFactor);
      controller.value = zoomedMatrix;
    }
  }

  void _zoomOut() {
    final matrix = controller.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      final zoomFactor = 0.8;
      final zoomedMatrix = matrix.clone()..scale(zoomFactor);
      controller.value = zoomedMatrix;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(icon: const Icon(Icons.add), onPressed: _zoomIn),
              const Divider(height: 1),
              IconButton(icon: const Icon(Icons.remove), onPressed: _zoomOut),
            ],
          ),
        ),
      ],
    );
  }
}
