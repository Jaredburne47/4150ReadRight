import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class FeedbackPlaceholder extends StatefulWidget {
  final String word;
  final String recognized;
  final double score;
  final String audioPath;

  const FeedbackPlaceholder({
    super.key,
    required this.word,
    required this.recognized,
    required this.score,
    required this.audioPath,
  });

  @override
  State<FeedbackPlaceholder> createState() => _FeedbackPlaceholderState();
}

class _FeedbackPlaceholderState extends State<FeedbackPlaceholder> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.stopPlayer();
      setState(() => _isPlaying = false);
    } else {
      await _player.startPlayer(fromURI: widget.audioPath);
      setState(() => _isPlaying = true);
      _player.onProgress!.listen((_) {
        if (!_player.isPlaying) setState(() => _isPlaying = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Feedback for "${widget.word}"',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Recognized: "${widget.recognized}"',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Score: ${(widget.score * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            label: Text(_isPlaying ? 'Stop Audio' : 'Play Audio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Practice'),
          ),
        ],
      ),
    );
  }
}