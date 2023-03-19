import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaData extends StatelessWidget {
  const MediaData(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.artist});

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(2, 4))
            ], borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 300,
                width: 300,
              ),
            )),
        const SizedBox(height: 20),
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(artist, style: const TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center),
      ],
    );
  }
}
