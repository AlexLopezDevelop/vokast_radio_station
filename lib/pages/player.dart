import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/radio.dart';

class PlayerArguments {
  final RadioModel radioModel;

  PlayerArguments(this.radioModel);
}

class Player extends StatefulWidget {
  static const routeName = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl("");
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlayerArguments;

    setState(() {
      audioPlayer.setUrl(args.radioModel.url);
      print(audioPlayer);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF144771),
                Color(0xFF071A2C),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Controls(audioPlayer: audioPlayer)
            ],
          ),
        ));
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (!(playing ?? false)) {
            return IconButton(
              onPressed: audioPlayer.play,
              iconSize: 80,
              color: Colors.white,
              icon: const Icon(Icons.play_arrow_rounded),
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              onPressed: audioPlayer.pause,
              iconSize: 80,
              color: Colors.white,
              icon: const Icon(Icons.pause_rounded),
            );
          }
          return const Icon(
            Icons.play_arrow_rounded,
            size: 80,
            color: Colors.white,
          );
        });
  }
}
