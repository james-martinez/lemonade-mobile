import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_mobile/widgets/chat_input.dart';
import 'package:lemonade_mobile/utils/constants.dart';

void main() {
  testWidgets('ChatInput correctly respects bottom safe area on Android 15/16', (WidgetTester tester) async {
    // Set up a simulated Android device window with a 48px bottom safe area.
    tester.view.physicalSize = const Size(1080, 2400); // Typical large phone
    tester.view.devicePixelRatio = 3.0; // 360x800 logical pixels
    // Define a 48px physical safe area at the bottom representing the gesture/nav bar
    tester.view.padding = FakeViewPadding(bottom: 48.0 * 3.0);

    // Build the widget tree
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            backgroundColor: AppTheme.darkTheme.colorScheme.surface,
            body: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChatInput(),
              ],
            ),
          ),
        ),
      ),
    );

    // Give it a frame to layout
    await tester.pumpAndSettle();

    // Take a screenshot of the entire scaffold to see the chat input and its spacing
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/chat_input_safe_area.png'),
    );

    // Reset view configurations
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.resetPadding();
  });
}
