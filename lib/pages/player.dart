import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../components/media_data.dart';
import '../models/radio.dart';

class PlayerArguments {
  final RadioModel radioModel;

  PlayerArguments(this.radioModel);
}

class PositionData {
  const PositionData(this.position, this.duration, this.bufferedPosition);

  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
}

class Player extends StatefulWidget {
  const Player({Key? key, required this.radioModel}) : super(key: key);

  final RadioModel radioModel;

  static const routeName = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer audioPlayer = AudioPlayer();

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration?, Duration, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        audioPlayer.bufferedPositionStream,
        (position, duration, bufferedPosition) =>
            PositionData(position, duration ?? Duration.zero, bufferedPosition),
      );

  get radioModel => widget.radioModel;

  @override
  void initState() {
    super.initState();
   audioPlayer = AudioPlayer();
   init();
  }

  Future init() async {

  }



  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(radioModel.url),
          tag: MediaItem(
            id: radioModel.id,
            title: radioModel.name,
            artUri: Uri.parse(radioModel.image),
          ),
        ),
      ]);

      audioPlayer.setUrl(radioModel.url);
      audioPlayer.setAudioSource(playlist);
      audioPlayer.setLoopMode(LoopMode.all);
      audioPlayer.play();
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
              StreamBuilder<PositionData>(
                  stream: positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return Column(children: [
                      MediaData(
                          imageUrl: radioModel.image,
                          title: radioModel.name,
                          artist: ""),
                      ProgressBar(
                          barHeight: 8,
                          baseBarColor: Colors.grey.shade600,
                          bufferedBarColor: Colors.grey,
                          progressBarColor: Colors.red,
                          thumbColor: Colors.red,
                          timeLabelTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                          progress: positionData?.position ?? Duration.zero,
                          total: positionData?.duration ?? Duration.zero,
                          buffered:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onSeek: audioPlayer.seek)
                    ]);
                  }),
              const SizedBox(height: 20),
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
