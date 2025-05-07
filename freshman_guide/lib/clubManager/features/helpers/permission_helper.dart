import 'package:permission_handler/permission_handler.dart';

Future<bool> _requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();
  return statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted;
}