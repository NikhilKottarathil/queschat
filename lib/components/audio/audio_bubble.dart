import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:queschat/components/audio/globals.dart';
import 'package:queschat/constants/styles.dart';

class AudioBubble extends StatefulWidget {
  const AudioBubble({Key key, @required this.filepath}) : super(key: key);

  final String filepath;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration duration;

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.filepath).then((value) {
      setState(() {
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return GestureDetector(
                  child: const Icon(Icons.play_arrow),
                  onTap: player.play,
                );
              } else if (playing != true) {
                return GestureDetector(
                  child: const Icon(Icons.play_arrow),
                  onTap: player.play,
                );
              } else if (processingState !=
                  ProcessingState.completed) {
                return GestureDetector(
                  child: const Icon(Icons.pause),
                  onTap: player.pause,
                );
              } else {
                return GestureDetector(
                  child: const Icon(Icons.replay),
                  onTap: () {
                    player.seek(Duration.zero);
                  },
                );
              }
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.5),
                      LinearProgressIndicator(
                        value: snapshot.data.inMilliseconds /
                            (duration?.inMilliseconds ?? 1),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prettyDuration(
                            snapshot.data == Duration.zero
                                ? duration ?? Duration.zero
                                : snapshot.data),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}
