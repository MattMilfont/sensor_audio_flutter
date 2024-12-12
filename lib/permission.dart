import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissions() async {
  await Permission.microphone.request();
  await Permission.storage.request();
}
