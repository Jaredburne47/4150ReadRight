import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class FeedbackScreen extends StatefulWidget {
  final String word;
  final String recognized;
  final double score;
  final String audioPath;

  const FeedbackScreen({
    super.key,
    required this.word,
    required this.recognized,
    required this.score,
    required this.audioPath,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
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
    if (widget.audioPath.isEmpty) return;
    if (_isPlaying) {
      await _player.stopPlayer();
      setState(() => _isPlaying = false);
    } else {
      await _player.startPlayer(
        fromURI: widget.audioPath,
        whenFinished: () => setState(() => _isPlaying = false),
      );
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.score * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Feedback',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🎯 Word: ${widget.word}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      '🗣️ You said: "${widget.recognized.isEmpty ? '—' : widget.recognized}"',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    Text('⭐ Score: $pct%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.score >= 0.7
                              ? Colors.green
                              : Colors.orange,
                        )),
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            label: Text(_isPlaying ? 'Stop Audio' : 'Play Audio'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Practice'),
            ),
          ),
        ]),
      ),
    );
  }
}