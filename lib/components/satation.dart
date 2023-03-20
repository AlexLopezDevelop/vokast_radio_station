import 'package:flutter/material.dart';
import 'package:vokast/models/radio.dart';
import 'package:vokast/pages/player.dart';

class StationCard extends StatelessWidget {
  const StationCard({super.key, required this.radio});

  final RadioModel radio;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15);
    return PhysicalModel(
        elevation: 3,
        color: Colors.white,
        borderRadius: border,
        child: ClipRRect(
          borderRadius: border,
          child: Image.network(
            radio.image,
            fit: BoxFit.cover,
          ),
        ));
  }
}