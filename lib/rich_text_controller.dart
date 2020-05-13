library rich_text_controller;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RichTextEditingController extends TextEditingController {
  final Map<RegExp, TextStyle> patternMap;
  RichTextEditingController(this.patternMap) : assert(patternMap != null);

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    List<TextSpan> children = [];
    RegExp allRegex;
    allRegex = RegExp(patternMap.keys.map((e) => e.pattern).join('|'));
    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        RegExp k = patternMap.entries.singleWhere((element) {
          return element.key.allMatches(m[0]).isNotEmpty;
        }).key;
        children.add(
          TextSpan(
            text: m[0],
            style: patternMap[k],
          ),
        );
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
      },
    );
    return TextSpan(style: style, children: children);
  }
}
