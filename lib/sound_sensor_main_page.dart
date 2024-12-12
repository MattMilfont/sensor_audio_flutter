import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'audio_sensor.dart'; // Substitua pelo arquivo correto da classe AudioSensor

class AudioSensorScreen extends StatefulWidget {
  const AudioSensorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioSensorScreenState createState() => _AudioSensorScreenState();
}

class _AudioSensorScreenState extends State<AudioSensorScreen> {
  final AudioSensor _audioSensor = AudioSensor();
  StreamSubscription<Uint8List>? _audioSubscription;
  double _currentVolume = 0.0;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioSensor();
  }

  Future<void> _initializeAudioSensor() async {
    try {
      await _audioSensor.initRecorder();
    } catch (e) {
      _showErrorDialog("Erro ao inicializar o sensor de áudio: $e");
    }
  }

  Future<void> _startListening() async {
    try {
      setState(() => _isListening = true);
      await _audioSensor.startListening();
      _audioSubscription = _audioSensor.audioStream.listen((audioData) {
        setState(() {
          _currentVolume = _calculateVolume(audioData);
        });
      });
    } catch (e) {
      setState(() => _isListening = false);
      _showErrorDialog("Erro ao iniciar a escuta: $e");
    }
  }

  Future<void> _stopListening() async {
    try {
      await _audioSensor.stopListening();
      await _audioSubscription?.cancel();
      setState(() {
        _isListening = false;
        _currentVolume = 0.0;
      });
    } catch (e) {
      _showErrorDialog("Erro ao parar a escuta: $e");
    }
  }

  double _calculateVolume(Uint8List audioData) {
    if (audioData.isEmpty) return 0.0;
    // Calcula o volume médio dos dados de áudio
    return audioData.map((e) => e.toDouble()).reduce((a, b) => a + b) /
        audioData.length;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioSensor.dispose();
    _audioSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor de Áudio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Volume Atual:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _isListening
                  ? '${_currentVolume.toStringAsFixed(2)} dB'
                  : 'Nenhum dado disponível',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isListening ? null : _startListening,
                  child: const Text('Iniciar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : null,
                  child: const Text('Parar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
