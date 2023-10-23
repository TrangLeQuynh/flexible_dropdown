// import 'package:flutter_test/flutter_test.dart';
// import 'package:flexible_dropdown/flexible_dropdown.dart';
// import 'package:flexible_dropdown/flexible_dropdown_platform_interface.dart';
// import 'package:flexible_dropdown/flexible_dropdown_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlexibleDropdownPlatform
//     with MockPlatformInterfaceMixin
//     implements FlexibleDropdownPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final FlexibleDropdownPlatform initialPlatform = FlexibleDropdownPlatform.instance;
//
//   test('$MethodChannelFlexibleDropdown is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlexibleDropdown>());
//   });
//
//   test('getPlatformVersion', () async {
//     FlexibleDropdown flexibleDropdownPlugin = FlexibleDropdown();
//     MockFlexibleDropdownPlatform fakePlatform = MockFlexibleDropdownPlatform();
//     FlexibleDropdownPlatform.instance = fakePlatform;
//
//     expect(await flexibleDropdownPlugin.getPlatformVersion(), '42');
//   });
// }
