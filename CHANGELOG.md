## 3.0.1
- **DOC**: Resizing of the demo gif and updated the source URL.
## 3.0.0
- **BREAKING CHANGE**: Removed `regExpCaseSensitive` property from `RichTextController`. Users must now set case sensitivity directly in the `RegExp` objects provided in `targetMatches`.
- **BREAKING CHANGE**: Updated the `MatchTargetItem` to include the `deleteOnBack` method to be able to set it exclusively for a certain match target.
- **FEAT**: Added IME composition support for languages like Japanese and Chinese. The `buildTextSpan` method now properly handles the `withComposing` parameter.
- **FEAT**: Added `updateTargetMatches` method to `RichTextController` for dynamic updates to `targetMatches` without recreating the controller.
- **FEAT**: Added `onTap` method for the `MatchTargetItem` to be able to get a tap callback on a match.
- **FEAT**: Enhanced `RichWrapper` to dynamically update the `RichTextController` when `targetMatches` or other properties change.
- **FEAT**: Added `copyWith` method to `MatchTargetItem` for easier modification of match target configurations.
- **FIX**: Fixed IME composition underline not appearing during pre-edit text.
- **FIX**: Fixed exception during Chinese input with Apple keyboard by validating `composingRange`.
- **FIX**: Fixed unintuitive behavior of `regExpCaseSensitive` overriding individual `RegExp` settings.
- **FIX**: Cached combined regex in `RichTextController` to improve performance.
- **FIX**: Improved error handling for invalid `targetMatches` and `composingRange`.
- **TEST**: Added testing for all of the controller's features, as well as the  rich_wrapper widget and the targetMatch model.
- **DOC**: Updated documentation for all public APIs, including `RichWrapper`, `RichTextController`, and `MatchTargetItem`.
- **DOC**: Added example usage and detailed explanations for all features in the README and API reference.
- **DEPS**: Updated SDK and package dependencies to the latest stable versions.
- **CHORE**: Improved error handling and validation in `MatchTargetItem` to ensure proper configuration of `text` and `regex`.
- **CHORE**: Refactored code for better readability and maintainability.
---

## 2.0.1
- **DOC**: Doc updates.

## 2.0.0
- **FIX**: Resolved Issues.
- **FEAT**: Added RichWrapper Widget.

---

## 1.4.2
- **FIX**: Resolved Issues.

## 1.4.0
- **FIX**: Resolved Issues.
- **FEAT**: Added deleteOnBack functionality.

## 1.3.0
- **FIX**: Resolved Issues.
- **FEAT**: Added Null safety.

## 1.2.0
- **FIX**: Resolved Issues.
- **FEAT**: Added String-Matching.

## 1.1.0
- **FEAT**: Added onMatch Callback.

## 1.0.1
- **DOC**: Added Example.

## 1.0.0
- **INIT**: First Release.

