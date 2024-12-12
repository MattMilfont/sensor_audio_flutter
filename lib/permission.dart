import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicrophonePermission() async {
  var status = await Permission.microphone.request();
  return status.isGranted;
}
