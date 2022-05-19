import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  void soundNumber(int noteNumber) {
    final player = AudioCache();
    player.play('note$noteNumber.wav');
  }

  Expanded soundButton({color, noteNumber}) {
    return Expanded(
      child: FlatButton(
        color: color,
        onPressed: () {
          soundNumber(noteNumber);
        },
        child: Text(''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                soundButton(color: Colors.red, noteNumber: 1),
                soundButton(color: Colors.orange, noteNumber: 2),
                soundButton(color: Colors.yellow, noteNumber: 3),
                soundButton(color: Colors.green, noteNumber: 4),
                soundButton(color: Colors.teal, noteNumber: 5),
                soundButton(color: Colors.blue, noteNumber: 6),
                soundButton(color: Colors.purple, noteNumber: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
