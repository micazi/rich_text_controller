import 'package:flutter/widgets.dart';

/// Match item model for the [RichTextController].
class MatchTargetItem {
  final String? text;
  final RegExp? regex;
  final TextStyle style;
  //
  final bool allowInlineMatching;
  MatchTargetItem({
    this.text,
    this.regex,
    required this.style,
    this.allowInlineMatching = false,
  }) : assert((text == null && regex != null) || (text != null && regex == null), "Only either text or regex should be supplied!");
  //

  MatchTargetItem copyWith({
    String? text,
    RegExp? regex,
    TextStyle? style,
    bool? allowInlineMatching,
  }) {
    return MatchTargetItem(
      text: text ?? this.text,
      regex: regex ?? this.regex,
      style: style ?? this.style,
      allowInlineMatching: allowInlineMatching ?? this.allowInlineMatching,
    );
  }

  @override
  String toString() {
    return 'MatchTargetItem(text: $text, regex: $regex, style: $style, allowInlineMatching: $allowInlineMatching)';
  }

  @override
  bool operator ==(covariant MatchTargetItem other) {
    if (identical(this, other)) return true;

    return other.text == text && other.regex == regex && other.style == style && other.allowInlineMatching == allowInlineMatching;
  }

  @override
  int get hashCode {
    return text.hashCode ^ regex.hashCode ^ style.hashCode ^ allowInlineMatching.hashCode;
  }
}
