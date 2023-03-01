library rich_text_controller;

import 'package:flutter/widgets.dart';

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
///
///  TextFormField(
///  controller: _controller,
///  ...
/// )
///
/// ```
/// {@end-tool}
class RichTextController extends TextEditingController {
  final Map<RegExp, TextStyle>? patternMatchMap;
  final Map<String, TextStyle>? stringMatchMap;
  final Function(List<String> match) onMatch;
  final bool? deleteOnBack;
  String _lastValue = "";

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  RichTextController({
    String? text,
    this.patternMatchMap,
    this.stringMatchMap,
    required this.onMatch,
    this.deleteOnBack = false,
  })  : assert((patternMatchMap != null && stringMatchMap == null) ||
            (patternMatchMap == null && stringMatchMap != null)),
        super(text: text);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> matches = [];

    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMatchMap != null
        ? RegExp(patternMatchMap?.keys.map((e) => e.pattern).join('|') ?? "")
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMatchMap != null
        ? RegExp(r'\b' + stringMatchMap!.keys.join('|').toString() + r'+\b')
        : null;
    ////
    text.splitMapJoin(
      stringMatchMap == null ? allRegex! : stringRegex!,
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
      onMatch: (Match m) {
        if (!matches.contains(m[0])) matches.add(m[0]!);
        final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        final String? ks = stringMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
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
                style: stringMatchMap == null
                    ? patternMatchMap![k]
                    : stringMatchMap![ks],
              ),
            );
          }
        } else {
          children.add(
            TextSpan(
              text: m[0],
              style: stringMatchMap == null
                  ? patternMatchMap![k]
                  : stringMatchMap![ks],
            ),
          );
        }

        return (onMatch(matches) ?? '');
      },
    );

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }
}
