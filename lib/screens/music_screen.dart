import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/music_manager.dart';
import '../widgets/music_track_tile.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicManager>().loadPlaylist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music')),
      body: Consumer<MusicManager>(
        builder: (context, manager, _) {
          if (manager.playlist.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildNowPlaying(manager),
              Expanded(
                child: ListView.builder(
                  itemCount: manager.playlist.length,
                  itemBuilder: (context, index) {
                    final track = manager.playlist[index];
                    return MusicTrackTile(
                      track: track,
                      isPlaying: manager.currentIndex == index && manager.isPlaying,
                      onTap: () => manager.play(index),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNowPlaying(MusicManager manager) {
    final track = manager.currentTrack;
    if (track == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black26,
      child: Column(
        children: [
          Text(track.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(track.artist),
          const SizedBox(height: 8),
          StreamBuilder<Duration>(
            stream: manager.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: manager.durationStream,
                builder: (context, durationSnapshot) {
                  final duration = durationSnapshot.data ?? Duration.zero;
                  return Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          manager.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position)),
                          Text(_formatDuration(duration)),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: manager.previous,
              ),
              IconButton(
                icon: Icon(manager.isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                onPressed: () {
                  if (manager.isPlaying) {
                    manager.pause();
                  } else {
                    manager.resume();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: manager.next,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
