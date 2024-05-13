import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Map<Size, TestVariant<Object?>> _testedDevices = {
  const Size(1080, 2280): TargetPlatformVariant.only(TargetPlatform.android), // Pixel 4a
  const Size(1179, 2556): TargetPlatformVariant.only(TargetPlatform.iOS), // iPhone 15 Pro
  const Size(1290, 2796): TargetPlatformVariant.only(TargetPlatform.iOS), // iPad Pro 15 Pro Max
};

void testPulseProWidget(
  String description,
  Future<void> Function(WidgetTester) callback,
) {
  for (var device in _testedDevices.entries) {
    var size = device.key;
    var platform = device.value;

    testWidgets('$description ($size)', (widgetTester) async {
      await widgetTester.binding.setSurfaceSize(size);
      return callback(widgetTester);
    }, variant: platform);
  }
}

String? fromRichTextToPlainText(final Widget widget) {
  if (widget is RichText) {
    return widget.text.toPlainText();
  }
  return null;
}