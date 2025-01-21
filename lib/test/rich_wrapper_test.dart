import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../rich_text_controller.dart';

void main() {
  group('RichWrapper', () {
    testWidgets('should update RichTextController when targetMatches changes',
        (tester) async {
      final targetMatches = [
        MatchTargetItem.text(
          'test',
          style: const TextStyle(color: Colors.red),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RichWrapper(
              targetMatches: targetMatches,
              child: (controller) => TextField(controller: controller),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller as RichTextController;

      expect(controller.targetMatches, targetMatches);

      final newTargetMatches = [
        MatchTargetItem.text(
          'new',
          style: const TextStyle(color: Colors.blue),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RichWrapper(
              targetMatches: newTargetMatches,
              child: (controller) => TextField(controller: controller),
            ),
          ),
        ),
      );

      expect(controller.targetMatches, newTargetMatches);
    });

    testWidgets('should handle dynamic updates to RegExp properties',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RichWrapper(
              targetMatches: [
                MatchTargetItem.pattern(
                  r'\d+',
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
              regExpDotAll: true,
              regExpMultiLine: true,
              regExpUnicode: true,
              child: (controller) => TextField(controller: controller),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller as RichTextController;

      expect(controller.regExpDotAll, true);
      expect(controller.regExpMultiLine, true);
      expect(controller.regExpUnicode, true);
    });
  });
}
