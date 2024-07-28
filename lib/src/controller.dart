import 'package:flutter/widgets.dart';

import 'models/match_target_item.dart';

/// a custom controller based on [TextEditingController] used to activly style input text based on regex patterns and word matching
/// with some custom features.
/// {@tool snippet}
///
/// ```dart
/// class _ExampleState extends State<Example> {
///
///   late RichTextController _controller;
///
/// _controller = RichTextController(
///       deleteOnBack: true,
///       patternMatchMap: {
///         //Returns every Hashtag with red color
///         RegExp(r"\B#[a-zA-Z0-9]+\b"):
///             const TextStyle(color: Colors.red, fontSize: 22.0),
///         //Returns every Mention with blue color and bold style.
///         RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
///           fontWeight: FontWeight.w800,
///           color: Colors.blue,
///         ),
///       },
///       regExpCaseSensitive: false,
/// );
///
///  TextFormField(
///  controller: _controller,
///  ...
/// )
///
/// ```
/// {@end-tool}
class RichTextController extends TextEditingController {
  final List<MatchTargetItem> targetMatches;
  final Function(List<String> match) onMatch;
  final Function(List<Map<String, List<int>>>)? onMatchIndex;
  final bool? deleteOnBack;
  //
  String _lastValue = "";

  /// controls the caseSensitive property of the full [RegExp] used to pattern match
  final bool regExpCaseSensitive;

  /// controls the dotAll property of the full [RegExp] used to pattern match
  final bool regExpDotAll;

  /// controls the multiLine property of the full [RegExp] used to pattern match
  final bool regExpMultiLine;

  /// controls the unicode property of the full [RegExp] used to pattern match
  final bool regExpUnicode;

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  RichTextController({
    super.text,
    required this.targetMatches,
    required this.onMatch,
    this.onMatchIndex,
    this.deleteOnBack = false,
    this.regExpCaseSensitive = true,
    this.regExpDotAll = false,
    this.regExpMultiLine = false,
    this.regExpUnicode = false,
  });

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]).
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  /// Builds [TextSpan] from current editing value.
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    //
    List<TextSpan> children = [];
    final matches = <String>{};
    List<Map<String, List<int>>> matchIndex = [];
    // combined regex!
    String stringItemText = '';
    String regItemText = '';
    for (MatchTargetItem target in targetMatches) {
      String b = target.allowInlineMatching ? '' : r'\b';
      //
      if (target.text != null) {
        stringItemText =
            '${stringItemText.isEmpty ? "" : "$stringItemText|"}$b${target.text}';
      }
      if (target.regex != null) {
        regItemText =
            '${regItemText.isEmpty ? "" : "$regItemText|"}$b${target.regex!.pattern}';
      }
      //
    }

    // combined regex!
    RegExp allRegex = RegExp(
        (stringItemText.isEmpty ? '' : '$stringItemText|') + regItemText,
        multiLine: regExpMultiLine,
        caseSensitive: regExpCaseSensitive,
        dotAll: regExpDotAll,
        unicode: regExpUnicode);
    //
    text.splitMapJoin(
      allRegex,
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
      onMatch: (Match m) {
        if (m[0] == null) return '';

        String mTxt = m[0]!;
        matches.add(mTxt);
        //
        MatchTargetItem? matchedItem;
        try {
          matchedItem = targetMatches.firstWhere((r) {
            if (r.text != null) {
              // Equality judgment is used to prevent string rules from matching results obtained from Regex.
              return regExpCaseSensitive
                  ? r.text == mTxt
                  : r.text!.toLowerCase() == mTxt.toLowerCase();
            } else {
              return r.regex!.allMatches(mTxt).isNotEmpty;
            }
          });
        } catch (_) {}

        //
        if (deleteOnBack!) {
          if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              children.removeWhere((element) => element.text! == text);
              text = text.replaceRange(m.start, m.end, "");
              selection = selection.copyWith(
                baseOffset: m.end - (m.end - m.start),
                extentOffset: m.end - (m.end - m.start),
              );
            });
          } else {
            children.add(
              TextSpan(
                text: mTxt,
                style: matchedItem?.style ?? style,
              ),
            );
          }
        } else {
          children.add(
            TextSpan(
              text: mTxt,
              style: matchedItem?.style ?? style,
            ),
          );
        }
        final resultMatchIndex = matchValueIndex(m);
        if (resultMatchIndex != null && onMatchIndex != null) {
          matchIndex.add(resultMatchIndex);
          onMatchIndex!(matchIndex);
        }

        return (onMatch(List<String>.unmodifiable(matches)) ?? '');
      },
    );

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }

  Map<String, List<int>>? matchValueIndex(Match match) {
    final matchValue = match[0]?.replaceFirstMapped('#', (match) => '');
    if (matchValue != null) {
      final firstMatchChar = match.start + 1;
      final lastMatchChar = match.end - 1;
      final compactMatch = {
        matchValue: [firstMatchChar, lastMatchChar]
      };
      return compactMatch;
    }
    return null;
  }
}
