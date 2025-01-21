import 'package:flutter/widgets.dart';

/// A model class representing a match target for the [RichTextController].
///
/// This class defines how specific text patterns or exact strings should be matched
/// and styled within a `RichText` widget. It also supports additional behaviors like
/// inline matching, deletion on backspace, and tap callbacks.
class MatchTargetItem {
  /// The exact text to match. Either [text] or [regex] must be provided, but not both.
  final String? text;

  /// The regular expression to match. Either [text] or [regex] must be provided, but not both.
  final RegExp? regex;

  /// The text style to apply to the matched text.
  final TextStyle style;

  /// Whether the entire matched text should be deleted when the backspace key is pressed.
  final bool deleteOnBack;

  /// Whether the pattern can match within words (inline matching).
  final bool allowInlineMatching;

  /// A callback function that is triggered when the matched text is tapped.
  final Function(String match)? onTap;

  /// Creates a new [MatchTargetItem] instance.
  ///
  /// Either [text] or [regex] must be provided, but not both.
  ///
  /// - [text]: The exact text to match.
  /// - [regex]: The regular expression to match.
  /// - [style]: The text style to apply to the matched text.
  /// - [allowInlineMatching]: Whether the pattern can match within words. Defaults to `false`.
  /// - [deleteOnBack]: Whether the entire matched text should be deleted on backspace. Defaults to `false`.
  /// - [onTap]: A callback function triggered when the matched text is tapped.
  ///
  /// Throws an [ArgumentError] if both [text] and [regex] are provided or if neither is provided.
  MatchTargetItem({
    this.text,
    this.regex,
    required this.style,
    this.allowInlineMatching = false,
    this.deleteOnBack = false,
    this.onTap,
  }) {
    validate();
  }

  /// Creates a [MatchTargetItem] from a RegExp pattern string.
  ///
  /// - [pattern]: The regular expression pattern as a string.
  /// - [style]: The text style to apply to the matched text.
  /// - [allowInlineMatching]: Whether the pattern can match within words. Defaults to `false`.
  /// - [deleteOnBack]: Whether the entire matched text should be deleted on backspace. Defaults to `false`.
  /// - [onTap]: A callback function triggered when the matched text is tapped.
  ///
  /// Returns a new [MatchTargetItem] configured with the provided pattern.
  factory MatchTargetItem.pattern(
    String pattern, {
    required TextStyle style,
    bool allowInlineMatching = false,
    bool deleteOnBack = false,
    Function(String match)? onTap,
  }) {
    return MatchTargetItem(
      regex: RegExp(pattern),
      style: style,
      allowInlineMatching: allowInlineMatching,
      deleteOnBack: deleteOnBack,
      onTap: onTap,
    );
  }

  /// Creates a [MatchTargetItem] specifically for exact text matching.
  ///
  /// - [text]: The exact text to match.
  /// - [style]: The text style to apply to the matched text.
  /// - [allowInlineMatching]: Whether the pattern can match within words. Defaults to `false`.
  /// - [deleteOnBack]: Whether the entire matched text should be deleted on backspace. Defaults to `false`.
  /// - [onTap]: A callback function triggered when the matched text is tapped.
  ///
  /// Returns a new [MatchTargetItem] configured with the provided text.
  factory MatchTargetItem.text(
    String text, {
    required TextStyle style,
    bool allowInlineMatching = false,
    bool deleteOnBack = false,
    Function(String match)? onTap,
  }) {
    return MatchTargetItem(
      text: text,
      style: style,
      allowInlineMatching: allowInlineMatching,
      deleteOnBack: deleteOnBack,
      onTap: onTap,
    );
  }

  /// Validates the configuration of this [MatchTargetItem].
  ///
  /// Throws an [ArgumentError] if:
  /// - Both [text] and [regex] are provided.
  /// - Neither [text] nor [regex] is provided.
  /// - [text] is provided but is empty.
  /// - [regex] is provided but its pattern is empty.
  void validate() {
    if (text == null && regex == null) {
      throw ArgumentError('Either text or regex must be provided');
    }
    if (text != null && regex != null) {
      throw ArgumentError('Only one of text or regex should be provided');
    }
    if (text != null && text!.isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }
    if (regex != null && regex!.pattern.isEmpty) {
      throw ArgumentError('Regex pattern cannot be empty');
    }
  }

  /// Creates a copy of this [MatchTargetItem] with optional parameter overrides.
  ///
  /// - [text]: Overrides the exact text to match.
  /// - [regex]: Overrides the regular expression to match.
  /// - [style]: Overrides the text style to apply to the matched text.
  /// - [allowInlineMatching]: Overrides whether the pattern can match within words.
  /// - [deleteOnBack]: Overrides whether the entire matched text should be deleted on backspace.
  /// - [onTap]: Overrides the callback function triggered when the matched text is tapped.
  ///
  /// Returns a new [MatchTargetItem] with the updated configuration.
  MatchTargetItem copyWith({
    String? text,
    RegExp? regex,
    TextStyle? style,
    bool? allowInlineMatching,
    bool? deleteOnBack,
    Function(String match)? onTap,
  }) {
    return MatchTargetItem(
      text: text ?? this.text,
      regex: regex ?? this.regex,
      style: style ?? this.style,
      allowInlineMatching: allowInlineMatching ?? this.allowInlineMatching,
      deleteOnBack: deleteOnBack ?? this.deleteOnBack,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  String toString() {
    return 'MatchTargetItem(text: $text, regex: $regex, style: $style, '
        'allowInlineMatching: $allowInlineMatching, deleteOnBack: $deleteOnBack, onTap: $onTap)';
  }

  @override
  bool operator ==(covariant MatchTargetItem other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.regex?.pattern == regex?.pattern &&
        other.style == style &&
        other.allowInlineMatching == allowInlineMatching &&
        other.deleteOnBack == deleteOnBack &&
        other.onTap == onTap;
  }

  @override
  int get hashCode {
    return Object.hash(
      text,
      regex?.pattern,
      style,
      allowInlineMatching,
      deleteOnBack,
      onTap,
    );
  }
}
