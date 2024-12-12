import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sensor_audio/permission.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AudioRecorder(),
    );
  }
}

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  double _volume = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    checkPermissions();
  }

  // Inicializa o gravador de áudio
  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(
        milliseconds: 100)); // Ajuste o tempo de intervalo para o volume
    _recorder.onProgress!.listen((e) {
      // Monitorando o volume durante a gravação
      if (e.decibels != null) {
        setState(() {
          _volume = e.decibels!;
        });
      }
    });
  }

  // Inicia a gravação de áudio
  Future<void> _startRecording() async {
    await _recorder.startRecorder(toFile: 'audio.aac');
    setState(() {
      _isRecording = true;
    });
  }

  // Para a gravação de áudio
  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor de Áudio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRecording
                  ? 'Detectando...'
                  : 'Pressione para começar a detectar',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(
                  _isRecording ? 'Parar de Detectar' : 'Começar a Detectar'),
            ),
            const SizedBox(height: 20),
            Text(
              'Volume Atual: ${_volume.toStringAsFixed(2)} dB',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
