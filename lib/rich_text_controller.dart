library rich_text_controller;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RichTextController extends TextEditingController {
  final Map<RegExp, TextStyle>? patternMap;
  final Map<String, TextStyle>? stringMap;
  final String Function(List<String> match)? onMatch;
  final bool deleteOnBack;
  bool clearMatch = false;

  RichTextController(
      {String? text,
      this.patternMap,
      this.stringMap,
      this.onMatch,
      this.deleteOnBack = false})
      : assert((patternMap != null && stringMap == null) ||
            (patternMap == null && stringMap != null)),
        super(text: text);

  RichTextController.fromValue(TextEditingValue value,
      {this.patternMap,
      this.stringMap,
      this.onMatch,
      this.deleteOnBack = false})
      : assert(
          !value.composing.isValid || value.isComposingRangeValid,
          'New TextEditingValue $value has an invalid non-empty composing range '
          '${value.composing}. It is recommended to use a valid composing range, '
          'even for readonly text fields',
        ),
        assert(patternMap == null || stringMap == null),
        super.fromValue(value);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final List<TextSpan> children = [];
    final List<String> matches = [];
    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMap != null
        ? RegExp(patternMap?.keys.map((e) => e.pattern).join('|') ?? "")
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMap != null
        ? RegExp(r'\b' + stringMap!.keys.join('|').toString() + r'+\b')
        : null;
    ////
    text.splitMapJoin(
      stringMap == null ? allRegex! : stringRegex!,
      onMatch: (Match m) {
        if (!matches.contains(m[0])) matches.add(m[0]!);
        final RegExp? k = patternMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        final String? ks = stringMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;

        children.add(
          TextSpan(
            text: m[0],
            style: stringMap == null ? patternMap![k] : stringMap![ks],
          ),
        );

        return (this.onMatch != null ? this.onMatch!(matches) : "");
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
    );

    return TextSpan(style: style, children: children);
  }
}
