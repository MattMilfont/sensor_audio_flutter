import 'dart:async';
import 'dart:typed_data';

class AudioSensor {
  final StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>();
  bool _isRecording = false;

  /// Inicializa o gravador de áudio
  Future<void> initRecorder() async {
    // Inicialize seu gravador de áudio aqui
    // Exemplo: await AudioRecorder.initialize();
  }

  /// Inicia a gravação e envia dados para o StreamController
  Future<void> startListening() async {
    if (_isRecording) return;
    _isRecording = true;

    // Simulação de dados de áudio
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isRecording) {
        timer.cancel();
      } else {
        final audioData =
            Uint8List.fromList(List.generate(256, (index) => index % 256));
        _audioStreamController.add(audioData);
      }
    });
  }

  /// Para a gravação
  Future<void> stopListening() async {
    _isRecording = false;
  }

  /// Getter para expor o Stream de áudio
  Stream<Uint8List> get audioStream => _audioStreamController.stream;

  /// Libera os recursos
  void dispose() {
    _audioStreamController.close();
  }
}
