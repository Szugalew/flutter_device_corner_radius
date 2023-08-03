import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'device_corner_radius_platform_interface.dart';

/// An implementation of [DeviceCornerRadiusPlatform] that uses method channels.
class MethodChannelDeviceCornerRadius extends DeviceCornerRadiusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_corner_radius');

  @override
  Future<BorderRadius> getCornerRadius(double devicePixelRatio) async {
    final adjustment = Platform.isIOS ? 1.0 : devicePixelRatio;
    double getRadius(Object obj) => (double.tryParse(obj.toString()) ?? 0) / adjustment;

    final radii = await methodChannel.invokeMethod('getCornerRadius');
    try {
      radii as Map;
      return BorderRadius.only(
        topLeft: Radius.circular(getRadius(radii['topLeft'])),
        topRight: Radius.circular(getRadius(radii['topRight'])),
        bottomLeft: Radius.circular(getRadius(radii['bottomLeft'])),
        bottomRight: Radius.circular(getRadius(radii['bottomRight'])),
      );
    } catch (e) {
      throw Exception('Failed to parse radii ');
    }
  }
}
