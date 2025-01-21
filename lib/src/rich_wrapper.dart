import 'package:flutter/material.dart';
import 'controller.dart';
import 'models/match_target_item.model.dart';

/// A wrapper widget around text fields that provides real-time updates for the [RichTextController]'s matching parameters.
///
/// This widget is designed to work with [RichTextController] to apply styles and behaviors
/// to specific text patterns or exact strings within a text field. It supports features like
/// inline matching, deletion on backspace, and callbacks for matched text.
///
/// Example usage:
/// ```dart
/// RichWrapper(
///   targetMatches: [
///     MatchTargetItem.text(
///       'coco',
///       style: TextStyle(
///         color: Colors.blue,
///         backgroundColor: Colors.green,
///       ),
///       allowInlineMatching: true,
///     ),
///   ],
///   child: (controller) => TextField(controller: controller),
/// );
/// ```
class RichWrapper extends StatefulWidget {
  /// The initial text to be displayed in the text field.
  final String? initialText;

  /// A list of [MatchTargetItem] objects defining the text patterns or exact strings to match
  /// and their corresponding styles and behaviors.
  final List<MatchTargetItem> targetMatches;

  /// A callback function triggered when matches are found.
  /// The callback provides a list of matched strings.
  final Function(List<String> match)? onMatch;

  /// A callback function triggered with the indices of matches.
  /// The callback provides a list of maps, where each map contains the matched string
  /// and its corresponding indices in the text.
  final Function(List<Map<String, List<int>>>)? onMatchIndex;

  /// Whether to delete the entire matched text when the backspace key is pressed.
  final bool? deleteOnBack;

  /// Controls the `dotAll` property of the [RegExp] used for pattern matching.
  /// When `true`, the `.` in the regex will match newline characters.
  final bool regExpDotAll;

  /// Controls the `multiLine` property of the [RegExp] used for pattern matching.
  /// When `true`, the `^` and `$` anchors will match the start and end of lines.
  final bool regExpMultiLine;

  /// Controls the `unicode` property of the [RegExp] used for pattern matching.
  /// When `true`, the regex will support Unicode character properties.
  final bool regExpUnicode;

  /// A builder function that returns a widget (typically a [TextField] or [TextFormField])
  /// and accepts a [RichTextController] as its argument.
  final Widget Function(RichTextController controller) child;

  /// Creates a new [RichWrapper] instance.
  ///
  /// - [initialText]: The initial text to display in the text field.
  /// - [targetMatches]: A list of [MatchTargetItem] objects defining the patterns to match.
  /// - [onMatch]: A callback triggered when matches are found.
  /// - [onMatchIndex]: A callback triggered with the indices of matches.
  /// - [deleteOnBack]: Whether to delete entire matches on backspace. Defaults to `false`.
  /// - [regExpDotAll]: Controls the `dotAll` property of the regex. Defaults to `false`.
  /// - [regExpMultiLine]: Controls the `multiLine` property of the regex. Defaults to `false`.
  /// - [regExpUnicode]: Controls the `unicode` property of the regex. Defaults to `false`.
  /// - [child]: A builder function that returns a widget using the [RichTextController].
  const RichWrapper({
    super.key,
    this.initialText,
    required this.targetMatches,
    this.onMatch,
    this.onMatchIndex,
    this.deleteOnBack = false,
    this.regExpDotAll = false,
    this.regExpMultiLine = false,
    this.regExpUnicode = false,
    required this.child,
  });

  @override
  State<RichWrapper> createState() => _RichWrapperState();
}

class _RichWrapperState extends State<RichWrapper> {
  late RichTextController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  /// Initializes the [RichTextController] with the provided parameters.
  void _initializeController() {
    _controller = RichTextController(
      text: widget.initialText ?? '',
      targetMatches: widget.targetMatches,
      onMatch: widget.onMatch ?? (_) {},
      onMatchIndex: widget.onMatchIndex ?? (_) {},
      regExpDotAll: widget.regExpDotAll,
      regExpMultiLine: widget.regExpMultiLine,
      regExpUnicode: widget.regExpUnicode,
    );
  }

  @override
  void didUpdateWidget(covariant RichWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller text if initialText changes
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText ?? '';
    }

    // Update target matches and regex properties if necessary
    bool shouldUpdateMatches = oldWidget.targetMatches != widget.targetMatches;
    bool shouldUpdateRegExp = oldWidget.regExpDotAll != widget.regExpDotAll ||
        oldWidget.regExpMultiLine != widget.regExpMultiLine ||
        oldWidget.regExpUnicode != widget.regExpUnicode;

    if (shouldUpdateMatches) {
      _controller.updateTargetMatches(widget.targetMatches);
    }

    if (shouldUpdateRegExp) {
      _controller.updateRegExpProperties(
        dotAll: widget.regExpDotAll,
        multiLine: widget.regExpMultiLine,
        unicode: widget.regExpUnicode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
