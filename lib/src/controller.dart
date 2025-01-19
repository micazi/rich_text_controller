// import 'package:flutter/widgets.dart';

// import 'models/match_target_item.dart';

// /// a custom controller based on [TextEditingController] used to activly style input text based on regex patterns and word matching
// /// with some custom features.
// /// {@tool snippet}
// ///
// /// ```dart
// /// class _ExampleState extends State<Example> {
// ///
// ///   late RichTextController _controller;
// ///
// /// _controller = RichTextController(
// ///       deleteOnBack: true,
// ///       patternMatchMap: {
// ///         //Returns every Hashtag with red color
// ///         RegExp(r"\B#[a-zA-Z0-9]+\b"):
// ///             const TextStyle(color: Colors.red, fontSize: 22.0),
// ///         //Returns every Mention with blue color and bold style.
// ///         RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
// ///           fontWeight: FontWeight.w800,
// ///           color: Colors.blue,
// ///         ),
// ///       },
// ///       regExpCaseSensitive: false,
// /// );
// ///
// ///  TextFormField(
// ///  controller: _controller,
// ///  ...
// /// )
// ///
// /// ```
// /// {@end-tool}
// class RichTextController extends TextEditingController {
//   final List<MatchTargetItem> targetMatches;
//   final Function(List<String> match) onMatch;
//   final Function(List<Map<String, List<int>>>)? onMatchIndex;
//   final bool? deleteOnBack;
//   //
//   String _lastValue = "";

//   /// controls the caseSensitive property of the full [RegExp] used to pattern match
//   final bool regExpCaseSensitive;

//   /// controls the dotAll property of the full [RegExp] used to pattern match
//   final bool regExpDotAll;

//   /// controls the multiLine property of the full [RegExp] used to pattern match
//   final bool regExpMultiLine;

//   /// controls the unicode property of the full [RegExp] used to pattern match
//   final bool regExpUnicode;

//   bool isBack(String current, String last) {
//     return current.length < last.length;
//   }

//   RichTextController({
//     super.text,
//     required this.targetMatches,
//     required this.onMatch,
//     this.onMatchIndex,
//     this.deleteOnBack = false,
//     this.regExpCaseSensitive = true,
//     this.regExpDotAll = false,
//     this.regExpMultiLine = false,
//     this.regExpUnicode = false,
//   });

//   /// Setting this will notify all the listeners of this [TextEditingController]
//   /// that they need to update (it calls [notifyListeners]).
//   @override
//   set text(String newText) {
//     value = value.copyWith(
//       text: newText,
//       selection: const TextSelection.collapsed(offset: -1),
//       composing: TextRange.empty,
//     );
//   }

//   /// Builds [TextSpan] from current editing value.
//   @override
//   TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
//     List<TextSpan> children = [];
//     final matches = <String>{};
//     List<Map<String, List<int>>> matchIndex = [];
//     // combined regex!
//     String regItemText = '';
//     String stringItemText = '';
//     for (MatchTargetItem target in targetMatches) {
//       //
//       if (target.regex != null) {
//         regItemText = '${regItemText.isNotEmpty ? '|$regItemText' : regItemText}${!target.allowInlineMatching ? '\\b' : ''}${target.regex!.pattern}';
//       }
//       if (target.text != null) {
//         stringItemText = '${stringItemText.length > 1 ? '$stringItemText|' : stringItemText}${!target.allowInlineMatching ? '\\b' : ''}${target.text}';
//       }
//       //
//     }
//     // combined regex!
//     RegExp allRegex = RegExp((stringItemText.length > 1 ? "$stringItemText|" : stringItemText) + regItemText,
//         multiLine: regExpMultiLine, caseSensitive: regExpCaseSensitive, dotAll: regExpDotAll, unicode: regExpUnicode);
//     //
//     text.splitMapJoin(
//       allRegex,
//       onNonMatch: (String span) {
//         children.add(TextSpan(text: span, style: style));
//         return span.toString();
//       },
//       onMatch: (Match m) {
//         matches.add(m[0]!);
//         //
//         final MatchTargetItem? matchedItem = targetMatches.where((r) => (r.regex != null ? r.regex!.allMatches(m[0]!).isNotEmpty : r.text!.allMatches(m[0]!).isNotEmpty)).isNotEmpty
//             ? targetMatches.firstWhere((e) {
//                 return (e.regex != null ? e.regex!.allMatches(m[0]!).isNotEmpty : e.text!.allMatches(m[0]!).isNotEmpty);
//               })
//             : null;
//         //
//         if (deleteOnBack!) {
//           if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               children.removeWhere((element) => element.text! == text);
//               text = text.replaceRange(m.start, m.end, "");
//               selection = selection.copyWith(
//                 baseOffset: m.end - (m.end - m.start),
//                 extentOffset: m.end - (m.end - m.start),
//               );
//             });
//           } else {
//             children.add(
//               TextSpan(
//                 text: m[0],
//                 style: matchedItem?.style ?? style,
//               ),
//             );
//           }
//         } else {
//           children.add(
//             TextSpan(
//               text: m[0],
//               style: matchedItem?.style ?? style,
//             ),
//           );
//         }
//         final resultMatchIndex = matchValueIndex(m);
//         if (resultMatchIndex != null && onMatchIndex != null) {
//           matchIndex.add(resultMatchIndex);
//           onMatchIndex!(matchIndex);
//         }

//         return (onMatch(List<String>.unmodifiable(matches)) ?? '');
//       },
//     );

//     _lastValue = text;
//     return TextSpan(style: style, children: children);
//   }

//   Map<String, List<int>>? matchValueIndex(Match match) {
//     final matchValue = match[0]?.replaceFirstMapped('#', (match) => '');
//     if (matchValue != null) {
//       final firstMatchChar = match.start + 1;
//       final lastMatchChar = match.end - 1;
//       final compactMatch = {
//         matchValue: [firstMatchChar, lastMatchChar]
//       };
//       return compactMatch;
//     }
//     return null;
//   }
// }

import 'package:flutter/widgets.dart';
import 'models/match_target_item.dart';

/// A custom controller based on [TextEditingController] used to actively style input text
/// based on regex patterns and word matching with some custom features.
/// {@tool snippet}
///
/// ```dart
/// class _ExampleState extends State<Example> {
///
///   late RichTextController _controller;
///
/// _controller = RichTextController(
///       deleteOnBack: true,
///       targetMatches: [
///         MatchTargetItem(
///           text: 'coco',
///           style: TextStyle(
///             color: Colors.red,
///             fontSize: 22.0,
///           ),
///         ),
///         MatchTargetItem(
///           regex: RegExp(r"\B@[a-zA-Z0-9]+\b"),
///           style: TextStyle(
///             fontWeight: FontWeight.w800,
///             color: Colors.blue,
///           ),
///         ),
///       ],
///       onMatch: (matches) {
///         print(matches);
///       },
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

  /// Controls the dotAll property of the full [RegExp] used to pattern match
  final bool regExpDotAll;

  /// Controls the multiLine property of the full [RegExp] used to pattern match
  final bool regExpMultiLine;

  /// Controls the unicode property of the full [RegExp] used to pattern match
  final bool regExpUnicode;

  /// Cached regex to avoid recompiling on every text change
  RegExp? _cachedRegex;
  List<MatchTargetItem>? _cachedTargetMatches;

  RichTextController({
    super.text,
    required this.targetMatches,
    required this.onMatch,
    this.onMatchIndex,
    this.deleteOnBack = false,
    this.regExpDotAll = false,
    this.regExpMultiLine = false,
    this.regExpUnicode = false,
  });

  /// Updates the target matches dynamically without recreating the controller
  void updateTargetMatches(List<MatchTargetItem> newTargetMatches) {
    targetMatches.clear();
    targetMatches.addAll(newTargetMatches);
    _cachedRegex = null; // Invalidate the cached regex
    notifyListeners(); // Notify listeners to rebuild the text span
  }

  /// Builds [TextSpan] from the current editing value.
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<TextSpan> children = [];
    final matches = <String>{};
    List<Map<String, List<int>>> matchIndex = [];

    // Handle composing text for IME input (e.g., Japanese, Chinese)
    if (withComposing && value.composing.isValid && !value.composing.isCollapsed) {
      final composingText = value.composing.textInside(value.text);
      children.add(TextSpan(
        text: composingText,
        style: style?.merge(const TextStyle(decoration: TextDecoration.underline)),
      ));
    }

    // Build the combined regex if not already cached
    final allRegex = _getCombinedRegex(targetMatches);

    // Split and match text
    text.splitMapJoin(
      allRegex,
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
      onMatch: (Match m) {
        matches.add(m[0]!);
        final MatchTargetItem? matchedItem = targetMatches.where((r) => (r.regex != null ? r.regex!.allMatches(m[0]!).isNotEmpty : r.text!.allMatches(m[0]!).isNotEmpty)).isNotEmpty
            ? targetMatches.firstWhere((e) {
                return (e.regex != null ? e.regex!.allMatches(m[0]!).isNotEmpty : e.text!.allMatches(m[0]!).isNotEmpty);
              })
            : null;

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
                text: m[0],
                style: matchedItem?.style ?? style,
              ),
            );
          }
        } else {
          children.add(
            TextSpan(
              text: m[0],
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

  /// Generates the combined regex for all target matches
  RegExp _getCombinedRegex(List<MatchTargetItem> targetMatches) {
    if (_cachedRegex != null && _cachedTargetMatches == targetMatches) {
      return _cachedRegex!;
    }

    String regItemText = '';
    String stringItemText = '';
    for (MatchTargetItem target in targetMatches) {
      if (target.regex != null) {
        regItemText = '${regItemText.isNotEmpty ? '|$regItemText' : regItemText}${!target.allowInlineMatching ? '\\b' : ''}${target.regex!.pattern}';
      }
      if (target.text != null) {
        stringItemText = '${stringItemText.length > 1 ? '$stringItemText|' : stringItemText}${!target.allowInlineMatching ? '\\b' : ''}${target.text}';
      }
    }

    _cachedRegex = RegExp(
      (stringItemText.length > 1 ? "$stringItemText|" : stringItemText) + regItemText,
      multiLine: regExpMultiLine,
      dotAll: regExpDotAll,
      unicode: regExpUnicode,
    );
    _cachedTargetMatches = targetMatches;

    return _cachedRegex!;
  }

  /// Checks if the current text change is a backspace operation
  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  /// Extracts match value and its index range
  Map<String, List<int>>? matchValueIndex(Match match) {
    final matchValue = match[0]?.replaceFirstMapped('#', (match) => '');
    if (matchValue != null && matchValue.isNotEmpty) {
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
