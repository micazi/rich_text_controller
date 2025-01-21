import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../rich_text_controller.dart';

void main() {
  group('MatchTargetItem', () {
    test('should throw ArgumentError if both text and regex are null', () {
      expect(
        () => MatchTargetItem(style: const TextStyle()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError if both text and regex are provided', () {
      expect(
        () => MatchTargetItem(
          text: 'test',
          regex: RegExp('test'),
          style: const TextStyle(),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError if text is empty', () {
      expect(
        () => MatchTargetItem(text: '', style: const TextStyle()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError if regex pattern is empty', () {
      expect(
        () => MatchTargetItem(regex: RegExp(''), style: const TextStyle()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should create a MatchTargetItem with text', () {
      final item = MatchTargetItem.text(
        'test',
        style: const TextStyle(color: Colors.red),
      );
      expect(item.text, 'test');
      expect(item.style, const TextStyle(color: Colors.red));
    });

    test('should create a MatchTargetItem with regex', () {
      final item = MatchTargetItem.pattern(
        r'\d+',
        style: const TextStyle(color: Colors.blue),
      );
      expect(item.regex, isA<RegExp>());
      expect(item.regex!.pattern, r'\d+');
      expect(item.style, const TextStyle(color: Colors.blue));
    });

    test('copyWith should create a new instance with updated values', () {
      final original = MatchTargetItem.text(
        'test',
        style: const TextStyle(color: Colors.red),
      );
      final copy = original.copyWith(
        text: 'new',
        style: const TextStyle(color: Colors.blue),
      );
      expect(copy.text, 'new');
      expect(copy.style, const TextStyle(color: Colors.blue));
    });

    test('equality and hashCode should work correctly', () {
      final item1 = MatchTargetItem.text(
        'test',
        style: const TextStyle(color: Colors.red),
      );
      final item2 = MatchTargetItem.text(
        'test',
        style: const TextStyle(color: Colors.red),
      );
      expect(item1, item2);
      expect(item1.hashCode, item2.hashCode);
    });
  });
}
