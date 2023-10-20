import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flexible_dropdown_method_channel.dart';

abstract class FlexibleDropdownPlatform extends PlatformInterface {
  /// Constructs a FlexibleDropdownPlatform.
  FlexibleDropdownPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlexibleDropdownPlatform _instance = MethodChannelFlexibleDropdown();

  /// The default instance of [FlexibleDropdownPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlexibleDropdown].
  static FlexibleDropdownPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlexibleDropdownPlatform] when
  /// they register themselves.
  static set instance(FlexibleDropdownPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
