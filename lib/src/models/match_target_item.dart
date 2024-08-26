import 'package:flutter/widgets.dart';

/// Match item model for the [RichTextController].
class MatchTargetItem {
  final String? text;
  final RegExp? regex;
  final TextStyle style;
  final VoidCallback? onTap;
  //
  final bool allowInlineMatching;
  MatchTargetItem({
    this.text,
    this.regex,
    required this.style,
    this.allowInlineMatching = false,
    this.onTap,
  }) : assert((text == null && regex != null) || (text != null && regex == null), "Only either text or regex should be supplied!");
  //

  MatchTargetItem copyWith({
    String? text,
    RegExp? regex,
    TextStyle? style,
    bool? allowInlineMatching,
    VoidCallback? onTap,
  }) {
    return MatchTargetItem(
      text: text ?? this.text,
      regex: regex ?? this.regex,
      style: style ?? this.style,
      allowInlineMatching: allowInlineMatching ?? this.allowInlineMatching,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  String toString() {
    return 'MatchTargetItem(text: $text, regex: $regex, style: $style, allowInlineMatching: $allowInlineMatching, onTap: $onTap)';
  }

  @override
  bool operator ==(covariant MatchTargetItem other) {
    if (identical(this, other)) return true;

    return other.text == text && other.regex == regex && other.style == style && other.allowInlineMatching == allowInlineMatching && other.onTap == onTap;
  }

  @override
  int get hashCode {
    return text.hashCode ^ regex.hashCode ^ style.hashCode ^ allowInlineMatching.hashCode ^ onTap.hashCode;
  }
}
