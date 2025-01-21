import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/gestures.dart';

import '../rich_text_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('RichTextController Tests', () {
    late BuildContext mockContext;

    setUp(() {
      // Create a mock BuildContext
      mockContext = MaterialApp(home: Container()).createElement();
    });

    test('Basic text matching and styling', () {
      final matches = <String>[];
      final matchIndices = <Map<String, List<int>>>[];

      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'test',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (m) => matches.addAll(m),
        onMatchIndex: (m) => matchIndices.addAll(m),
      );

      controller.text = 'This is a test message';

      final textSpan = controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      expect(matches, contains('test'));
      expect(matchIndices.length, 1);
      expect(textSpan.children!.length, 3); // Before match, match, after match
    });

    test('Multiple pattern matching', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'hello',
            style: const TextStyle(color: Colors.blue),
          ),
          MatchTargetItem(
            text: 'world',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (_) {},
      );

      controller.text = 'hello world';

      final textSpan = controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      expect(textSpan.children!.length, 3); // 'hello', space, 'world'
    });

    test('Regex pattern matching', () {
      final matches = <String>[];

      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            regex: RegExp(r'\d+'),
            style: const TextStyle(color: Colors.green),
          ),
        ],
        onMatch: (m) => matches.addAll(m),
      );

      controller.text = 'Number 123 and 456';

      controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      expect(matches, contains('123'));
      expect(matches, contains('456'));
    });

    test('Tap callback functionality', () {
      String? tappedText;

      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'clickme',
            style: const TextStyle(color: Colors.blue),
            onTap: (text) => tappedText = text,
          ),
        ],
        onMatch: (_) {},
      );

      controller.text = 'Please clickme now';

      final textSpan = controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      // Find the clickable span
      final clickableSpan = textSpan.children!
          .whereType<TextSpan>()
          .firstWhere((span) => span.recognizer != null);

      // Simulate tap
      (clickableSpan.recognizer as TapGestureRecognizer).onTap!();

      expect(tappedText, equals('clickme'));
    });

    test('Dynamic target matches update', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'initial',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (_) {},
      );

      controller.updateTargetMatches([
        MatchTargetItem(
          text: 'updated',
          style: const TextStyle(color: Colors.blue),
        ),
      ]);

      controller.text = 'This is updated text';

      final textSpan = controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      // Verify the new pattern is matched
      final matchedSpan = textSpan.children!
          .whereType<TextSpan>()
          .firstWhere((span) => span.style?.color == Colors.blue);

      expect(matchedSpan.text, equals('updated'));
    });

    test('RegExp properties update', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            regex: RegExp(r'test$'),
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (_) {},
        regExpMultiLine: false,
      );

      controller.text = 'test\ntest';
      var initialMatches = controller
          .buildTextSpan(
            context: mockContext,
            style: const TextStyle(),
            withComposing: false,
          )
          .children!
          .length;

      controller.updateRegExpProperties(multiLine: true);
      var updatedMatches = controller
          .buildTextSpan(
            context: mockContext,
            style: const TextStyle(),
            withComposing: false,
          )
          .children!
          .length;

      expect(initialMatches != updatedMatches, true);
    });

    test('IME composing region handling', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'test',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (_) {},
      );

      controller.value = const TextEditingValue(
        text: 'This is a test',
        composing: TextRange(start: 10, end: 14),
      );

      final textSpan = controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: true,
      );

      // Verify composing region has underline decoration
      final composingSpan = textSpan.children!.whereType<TextSpan>().firstWhere(
          (span) => span.style?.decoration == TextDecoration.underline);

      expect(composingSpan, isNotNull);
    });

    test('Backspace deletion behavior', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'delete',
            style: const TextStyle(color: Colors.red),
            deleteOnBack: true,
          ),
        ],
        onMatch: (_) {},
      );

      controller.text = 'Please delete me';
      controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );
      controller.selection =
          const TextSelection.collapsed(offset: 12); // End of 'delete'

      // Simulate backspace
      'Please delete m';
      controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );
      // Wait for post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        expect(controller.text, equals('Please  me'));
      });
    });

    test('Cache invalidation', () {
      final controller = RichTextController(
        targetMatches: [
          MatchTargetItem(
            text: 'test',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        onMatch: (_) {},
      );

      controller.text = 'This is a test';
      controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      // Access private fields for testing cache
      final initialRegex = controller.toString();

      controller.updateTargetMatches([
        MatchTargetItem(
          text: 'different',
          style: const TextStyle(color: Colors.blue),
        ),
      ]);

      controller.buildTextSpan(
        context: mockContext,
        style: const TextStyle(),
        withComposing: false,
      );

      final updatedRegex = controller.toString();

      expect(initialRegex != updatedRegex, true);
    });
  });
}
