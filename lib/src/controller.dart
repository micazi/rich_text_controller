// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'models/match_target_item.model.dart';

/// A custom [TextEditingController] that supports rich text styling based on regex patterns
/// and word matching. It allows you to highlight specific text patterns and apply custom styles
/// to matched text. Additionally, it supports dynamic updates, IME composition, and tap callbacks
/// for matched text.
class RichTextController extends TextEditingController {
  final List<MatchTargetItem> targetMatches;
  final Function(List<String> match) onMatch;
  final Function(List<Map<String, List<int>>>)? onMatchIndex;

  String _lastValue = "";
  Match? _matchUnderCursor; // Cache the match under the cursor
  MatchTargetItem?
      _matchedItemUnderCursor; // Cache the matched item under the cursor

  /// Controls the dotAll property of the full combined [RegExp] of the match targets in the controller.
  bool regExpDotAll;

  /// Controls the multiLine property of the full combined [RegExp] of the match targets in the controller.
  bool regExpMultiLine;

  /// Controls the unicode property of the full combined [RegExp] of the match targets in the controller.
  bool regExpUnicode;

  /// Cached regex pattern and compiled RegExp.
  RegExp? _cachedRegex;
  String? _cachedPattern;
  List<MatchTargetItem>? _cachedTargetMatches;

  /// Creates a new [RichTextController].
  ///
  /// - [text]: The initial text for the controller.
  /// - [targetMatches]: A list of [MatchTargetItem] objects defining the text or regex patterns
  ///   to match and their associated styles.
  /// - [onMatch]: A callback triggered when matches are found.
  /// - [onMatchIndex]: A callback triggered with the indices of matches.
  /// - [regExpDotAll]: Controls the dotAll property of the full [RegExp].
  /// - [regExpMultiLine]: Controls the multiLine property of the full [RegExp].
  /// - [regExpUnicode]: Controls the unicode property of the full [RegExp].
  RichTextController({
    super.text,
    required this.targetMatches,
    required this.onMatch,
    this.onMatchIndex,
    this.regExpDotAll = false,
    this.regExpMultiLine = false,
    this.regExpUnicode = false,
  });

  /// Updates the target matches dynamically.
  ///
  /// - [newTargetMatches]: The new list of [MatchTargetItem] objects to use for matching.
  void updateTargetMatches(List<MatchTargetItem> newTargetMatches) {
    targetMatches
      ..clear()
      ..addAll(newTargetMatches);
    _invalidateCache();
    notifyListeners();
  }

  /// Updates the RegExp properties dynamically.
  ///
  /// - [dotAll]: Whether to update the dotAll property of the full [RegExp].
  /// - [multiLine]: Whether to update the multiLine property of the full [RegExp].
  /// - [unicode]: Whether to update the unicode property of the full [RegExp].
  void updateRegExpProperties({
    bool? dotAll,
    bool? multiLine,
    bool? unicode,
  }) {
    bool changed = false;

    if (dotAll != null && dotAll != regExpDotAll) {
      regExpDotAll = dotAll;
      changed = true;
    }

    if (multiLine != null && multiLine != regExpMultiLine) {
      regExpMultiLine = multiLine;
      changed = true;
    }

    if (unicode != null && unicode != regExpUnicode) {
      regExpUnicode = unicode;
      changed = true;
    }

    if (changed) {
      _invalidateCache();
      notifyListeners();
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> children = [];
    final matches = <String>{};
    List<Map<String, List<int>>> matchIndex = [];

    // Get or create the combined regex
    final allRegex = _getCombinedRegex(targetMatches);

    // Find all matches
    final allMatches = allRegex.allMatches(text);

    // Handle IME composing region
    if (withComposing &&
        value.composing.isValid &&
        !value.composing.isCollapsed) {
      return _handleComposingText(style, allMatches, matches, matchIndex);
    }

    // Process matches if no IME composition is active
    children
        .addAll(_processText(text, style, allMatches, matches, matchIndex, 0));

    // Handle backspace deletion if enabled
    if (isBack(text, _lastValue) &&
        _matchUnderCursor != null &&
        _matchedItemUnderCursor != null &&
        _matchedItemUnderCursor!.deleteOnBack) {
      _handleBackspaceDelete();
    }

    // Trigger callbacks
    _triggerCallbacks(matches, matchIndex);

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }

  /// Handles IME composing text by splitting the text into non-composing and composing parts.
  ///
  /// - [style]: The base text style.
  /// - [allMatches]: All regex matches in the text.
  /// - [matches]: A set to store matched text.
  /// - [matchIndex]: A list to store match indices.
  TextSpan _handleComposingText(
    TextStyle? style,
    Iterable<Match> allMatches,
    Set<String> matches,
    List<Map<String, List<int>>> matchIndex,
  ) {
    List<TextSpan> children = [];
    final composingStart = value.composing.start;
    final composingEnd = value.composing.end;

    // Add text before the composing region
    if (composingStart > 0) {
      final nonComposingText = text.substring(0, composingStart);
      children.addAll(_processText(
          nonComposingText, style, allMatches, matches, matchIndex, 0));
    }

    // Add the composing text with the appropriate style
    final composingText = text.substring(composingStart, composingEnd);
    final matchedItem = _findMatchedItemForText(composingText);

    children.add(TextSpan(
      text: composingText,
      style: matchedItem.style.copyWith(
          decoration:
              TextDecoration.underline), // Apply underline to composing text
    ));

    // Add text after the composing region
    if (composingEnd < text.length) {
      final remainingText = text.substring(composingEnd);
      children.addAll(_processText(
          remainingText, style, allMatches, matches, matchIndex, composingEnd));
    }

    return TextSpan(style: style, children: children);
  }

  /// Processes the given text and generates [TextSpan]s for matched and non-matched text.
  ///
  /// - [text]: The text to process.
  /// - [style]: The base text style.
  /// - [allMatches]: All regex matches in the text.
  /// - [matches]: A set to store matched text.
  /// - [matchIndex]: A list to store match indices.
  /// - [startOffset]: The starting offset of the text segment.
  List<TextSpan> _processText(
    String text,
    TextStyle? style,
    Iterable<Match> allMatches,
    Set<String> matches,
    List<Map<String, List<int>>> matchIndex,
    int startOffset,
  ) {
    List<TextSpan> children = [];
    int lastMatchEnd = startOffset;

    for (final match in allMatches) {
      final matchStart = match.start - startOffset;
      final matchEnd = match.end - startOffset;

      if (matchStart < 0 || matchEnd > text.length) continue;

      // Add text before this match
      if (matchStart > lastMatchEnd - startOffset) {
        final nonMatchText =
            text.substring(lastMatchEnd - startOffset, matchStart);
        children.add(TextSpan(text: nonMatchText, style: style));
      }

      // Process the match
      final matchText = match.group(0)!;
      matches.add(matchText);

      final matchedItem = _findMatchedItemForText(matchText);
      children.add(_createTextSpanForMatch(matchText, matchedItem));

      // Check if the cursor is within this match
      _cacheMatchUnderCursor(match, matchedItem);

      lastMatchEnd = match.end;

      // Handle match index callback
      _addMatchIndex(matchText, match, matchIndex);
    }

    // Add any remaining text after the last match
    if (lastMatchEnd - startOffset < text.length) {
      final remainingText = text.substring(lastMatchEnd - startOffset);
      children.add(TextSpan(text: remainingText, style: style));
    }

    return children;
  }

  /// Finds the matching [MatchTargetItem] for the given text.
  ///
  /// - [text]: The text to match.
  MatchTargetItem _findMatchedItemForText(String text) {
    return targetMatches
            .where(
              (target) => target.regex?.hasMatch(text) ?? target.text == text,
            )
            .firstOrNull ??
        targetMatches.first;
  }

  /// Creates a [TextSpan] for the matched text with the appropriate style and onTap callback.
  ///
  /// - [text]: The matched text.
  /// - [matchedItem]: The [MatchTargetItem] associated with the matched text.
  TextSpan _createTextSpanForMatch(String text, MatchTargetItem matchedItem) {
    return TextSpan(
      text: text,
      style: matchedItem.style,
      recognizer: matchedItem.onTap != null
          ? (TapGestureRecognizer()..onTap = () => matchedItem.onTap!(text))
          : null,
    );
  }

  /// Caches the match and matched item under the cursor if the cursor is within the match.
  ///
  /// - [match]: The regex match.
  /// - [matchedItem]: The [MatchTargetItem] associated with the match.
  void _cacheMatchUnderCursor(Match match, MatchTargetItem matchedItem) {
    if (selection.baseOffset >= match.start &&
        selection.baseOffset <= match.end) {
      _matchUnderCursor = match;
      _matchedItemUnderCursor = matchedItem;
    }
  }

  /// Adds the match indices to the [matchIndex] list for the callback.
  ///
  /// - [matchText]: The matched text.
  /// - [match]: The regex match.
  /// - [matchIndex]: The list to store match indices.
  void _addMatchIndex(
      String matchText, Match match, List<Map<String, List<int>>> matchIndex) {
    if (onMatchIndex != null) {
      matchIndex.add({
        matchText: [match.start, match.end]
      });
    }
  }

  /// Handles backspace deletion of the match under the cursor.
  void _handleBackspaceDelete() {
    if (_matchUnderCursor != null &&
        selection.baseOffset == _matchUnderCursor!.end - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final newText = text.replaceRange(
            _matchUnderCursor!.start, _matchUnderCursor!.end - 1, "");
        value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: _matchUnderCursor!.start),
        );
        _matchUnderCursor = null; // Reset the cached match after deletion
        _matchedItemUnderCursor =
            null; // Reset the cached matched item after deletion
      });
    }
  }

  /// Triggers the [onMatch] and [onMatchIndex] callbacks if matches are found.
  ///
  /// - [matches]: The set of matched text.
  /// - [matchIndex]: The list of match indices.
  void _triggerCallbacks(
      Set<String> matches, List<Map<String, List<int>>> matchIndex) {
    if (matches.isNotEmpty) {
      onMatch(List<String>.unmodifiable(matches));
      if (onMatchIndex != null) {
        onMatchIndex!(matchIndex);
      }
    }
  }

  /// Generates a combined regex pattern from the target matches.
  ///
  /// - [targetMatches]: The list of [MatchTargetItem] objects.
  RegExp _getCombinedRegex(List<MatchTargetItem> targetMatches) {
    if (_cachedRegex != null &&
        _cachedTargetMatches != null &&
        _listEquals(_cachedTargetMatches!, targetMatches)) {
      return _cachedRegex!;
    }

    final StringBuffer buffer = StringBuffer();
    bool first = true;

    for (final target in targetMatches) {
      if (!first) buffer.write('|');

      if (target.regex != null) {
        // For regex patterns, use the pattern as-is if allowInlineMatching is true
        // or if the pattern already contains \B (non-word boundary).
        // Otherwise, wrap it with \b (word boundary).
        final pattern =
            target.allowInlineMatching || target.regex!.pattern.contains(r'\B')
                ? target.regex!.pattern
                : '\\b${target.regex!.pattern}\\b';
        buffer.write('($pattern)');
      } else if (target.text != null) {
        // For plain text, escape it and handle special cases like !del
        final escaped = RegExp.escape(target.text!);
        final pattern = target.allowInlineMatching
            ? escaped
            : target.text!.startsWith('!')
                ? '(?<!\\w)$escaped\\b' // Use lookbehind for !del
                : '\\b$escaped\\b'; // Use word boundary for others
        buffer.write('($pattern)');
      }

      first = false;
    }

    _cachedPattern = buffer.toString();
    _cachedTargetMatches = List.from(targetMatches);
    _cachedRegex = RegExp(
      _cachedPattern!,
      multiLine: regExpMultiLine,
      dotAll: regExpDotAll,
      unicode: regExpUnicode,
    );

    return _cachedRegex!;
  }

  /// Checks if two lists are equal.
  ///
  /// - [list1]: The first list.
  /// - [list2]: The second list.
  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (identical(list1, list2)) return true;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  /// Checks if the current text change is a backspace operation.
  ///
  /// - [current]: The current text.
  /// - [last]: The previous text.
  bool isBack(String current, String last) {
    return current.length <= last.length;
  }

  /// Invalidates the cached regex and related data.
  void _invalidateCache() {
    _cachedRegex = null;
    _cachedPattern = null;
    _cachedTargetMatches = null;
  }

  @override
  void dispose() {
    _invalidateCache();
    super.dispose();
  }

  @override
  String toString() {
    return 'RichTextController(targetMatches: $targetMatches, onMatch: $onMatch, onMatchIndex: $onMatchIndex, regExpDotAll: $regExpDotAll, regExpMultiLine: $regExpMultiLine, regExpUnicode: $regExpUnicode, _cachedRegex: $_cachedRegex, _cachedPattern: $_cachedPattern, _cachedTargetMatches: $_cachedTargetMatches)';
  }
}
