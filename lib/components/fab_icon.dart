import 'package:flutter/material.dart';

class FabIcon extends StatelessWidget {
  final String icon;
  final String title;

  const FabIcon({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
          height: 100,
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 25, color: Colors.grey)),
                ),
                )
              ),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )
      );
  }
}