import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flexible_dropdown_platform_interface.dart';

/// An implementation of [FlexibleDropdownPlatform] that uses method channels.
class MethodChannelFlexibleDropdown extends FlexibleDropdownPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flexible_dropdown');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
