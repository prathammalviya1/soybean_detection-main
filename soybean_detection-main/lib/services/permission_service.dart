import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    // Save a reference to context to check if it's still mounted later
    final contextRef = context;

    PermissionStatus status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      // Check if context is still valid
      if (contextRef.mounted) {
        _showPermissionDeniedDialog(
          contextRef,
          'Camera Access Required',
          'We need camera access to capture photos of soybean leaves for disease detection. Please enable it in the app settings.',
        );
      }
      return false;
    }

    return status.isGranted;
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    // Save a reference to context to check if it's still mounted later
    final contextRef = context;

    if (await _isAndroid13OrAbove()) {
      // For Android 13+ use photos permission
      PermissionStatus status = await Permission.photos.status;

      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isPermanentlyDenied) {
        // Check if context is still valid
        if (contextRef.mounted) {
          _showPermissionDeniedDialog(
            contextRef,
            'Photo Library Access Required',
            'We need access to your photos to select soybean leaf images for disease detection. Please enable it in the app settings.',
          );
        }
        return false;
      }

      return status.isGranted;
    } else {
      // For Android 12 and below use storage permission
      PermissionStatus status = await Permission.storage.status;

      if (status.isDenied) {
        status = await Permission.storage.request();
      }

      if (status.isPermanentlyDenied) {
        // Check if context is still valid
        if (contextRef.mounted) {
          _showPermissionDeniedDialog(
            contextRef,
            'Storage Access Required',
            'We need storage access to select soybean leaf images for disease detection. Please enable it in the app settings.',
          );
        }
        return false;
      }

      return status.isGranted;
    }
  }

  // Helper method to check if device is running Android 13+
  static Future<bool> _isAndroid13OrAbove() async {
    // The permissions.photos was introduced in Android 13
    return await Permission.photos.status.isGranted ||
        await Permission.photos.status.isDenied ||
        await Permission.photos.status.isPermanentlyDenied;
  }

  // Show a dialog when permission is permanently denied
  static void _showPermissionDeniedDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  // Generic method to request any permission with a custom message
  static Future<bool> requestPermission({
    required Permission permission,
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    // Save a reference to context to check if it's still mounted later
    final contextRef = context;

    PermissionStatus status = await permission.status;

    if (status.isDenied) {
      status = await permission.request();
    }

    if (status.isPermanentlyDenied) {
      // Check if context is still valid
      if (contextRef.mounted) {
        _showPermissionDeniedDialog(contextRef, title, message);
      }
      return false;
    }

    return status.isGranted;
  }
}
