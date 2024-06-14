//SECTION - Imports
//
//s1 PACKAGES
//---------------
//s2 CORE
import 'package:flutter/material.dart';

import '../controller.dart';
import '../models/match_target_item.dart';

//s2 3RD-PARTY
//
//s1 DEPENDENCIES
//---------------
//s2 SERVICES
//s2 MODELS
//s2 MISC
//!SECTION - Imports
//
//SECTION - Exports
//!SECTION - Exports
//
/// Wrapper widget around text fields that provides realtime updates for the [RichTextController]'s matching parameters.
///
/// ```dart
///
/// RichWrapper(
///       targetMatches: [
///         MatchTargetItem(
///             text: 'coco',
///             style: const TextStyle(
///               color: Colors.black,
///               backgroundColor: Colors.green,
///             ),
///              allowInlineMatching: true,
///         ),
///
///      ],
/// child: (con) => TextField(controller: con),
///   );
///
///```
class RichWrapper extends StatefulWidget {
  //SECTION - Widget Arguments
  final String? initialText;
  //
  final List<MatchTargetItem> targetMatches;
  final Function(List<String> match)? onMatch;
  final Function(List<Map<String, List<int>>>)? onMatchIndex;
  final bool? deleteOnBack;

  /// controls the caseSensitive property of the full [RegExp] used to pattern match
  final bool regExpCaseSensitive;

  /// controls the dotAll property of the full [RegExp] used to pattern match
  final bool regExpDotAll;

  /// controls the multiLine property of the full [RegExp] used to pattern match
  final bool regExpMultiLine;

  /// controls the unicode property of the full [RegExp] used to pattern match
  final bool regExpUnicode;
  //
  final Widget Function(RichTextController controller) child;
  //!SECTION
  //
  const RichWrapper({
    super.key,
    this.initialText,
    required this.targetMatches,
    this.onMatch,
    this.onMatchIndex,
    this.regExpCaseSensitive = true,
    this.regExpDotAll = false,
    this.regExpMultiLine = false,
    this.regExpUnicode = false,
    this.deleteOnBack = false,
    required this.child,
  });

  @override
  State<RichWrapper> createState() => _RichWrapperState();
}

class _RichWrapperState extends State<RichWrapper> {
  //
  //SECTION - State Variables
  //s1 --State
  String controllerText = '';
  //s1 --State
  //
  //s1 --Controllers
  late RichTextController _controller;
  //s1 --Controllers
  //
  //s1 --Constants
  //s1 --Constants
  //!SECTION

  @override
  void initState() {
    super.initState();
    //
    //SECTION - State Variables initializations & Listeners
    //s1 --State
    //s1 --State
    //
    //s1 --Controllers & Listeners
    _controller = RichTextController(
      text: widget.initialText,
      targetMatches: widget.targetMatches,
      onMatch: widget.onMatch ?? (x) {},
      deleteOnBack: widget.deleteOnBack,
      onMatchIndex: widget.onMatchIndex,
      regExpCaseSensitive: widget.regExpCaseSensitive,
      regExpDotAll: widget.regExpDotAll,
      regExpMultiLine: widget.regExpMultiLine,
      regExpUnicode: widget.regExpUnicode,
    );
    controllerText = _controller.text;
    //s1 --Controllers & Listeners
    //
    //s1 --Late & Async Initializers
    //s1 --Late & Async Initializers
    //!SECTION
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //
    //SECTION - State Variables initializations & Listeners
    //s1 --State
    //s1 --State
    //
    //s1 --Controllers & Listeners
    //s1 --Controllers & Listeners
    //
    //!SECTION
  }

  @override
  void didUpdateWidget(covariant RichWrapper oldWidget) {
    String t = _controller.text;
    _controller = RichTextController(
      text: t,
      targetMatches: widget.targetMatches,
      onMatch: widget.onMatch ?? (x) {},
      deleteOnBack: widget.deleteOnBack,
      onMatchIndex: widget.onMatchIndex,
      regExpCaseSensitive: widget.regExpCaseSensitive,
      regExpDotAll: widget.regExpDotAll,
      regExpMultiLine: widget.regExpMultiLine,
      regExpUnicode: widget.regExpUnicode,
    );
    super.didUpdateWidget(oldWidget);
  }

  //SECTION - Dumb Widgets
  //!SECTION

  //SECTION - Stateless functions
  //!SECTION

  //SECTION - Action Callbacks
  //!SECTION

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //s1 --Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //s1 --Values
    //
    //s1 --Contexted Widgets
    //s1 --Contexted Widgets
    //!SECTION

    //SECTION - Build Return
    return widget.child(_controller);
    //!SECTION
  }

  @override
  void dispose() {
    //SECTION - Disposable variables
    //!SECTION
    super.dispose();
  }
}
