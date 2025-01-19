## 3.0.0
- **DEPS** Updated SDK and packages dependencies.
- **DOC** Updated documents.
- **BREAKING CHANGE** Removed regExpCaseSensitive property from RichTextController. Users must now set case sensitivity directly in the RegExp objects provided in targetMatches.
- **FEAT** Added IME composition support for languages like Japanese and Chinese. The buildTextSpan method now properly handles the withComposing parameter.
- **FEAT** Added updateTargetMatches method to RichTextController for dynamic updates to targetMatches without recreating the controller.
- **FEAT** Enhanced RichWrapper to dynamically update the RichTextController when targetMatches or other properties change.
- **FIX** Fixed IME composition underline not appearing during pre-edit text.
- **FIX** Fixed exception during Chinese input with Apple keyboard by validating composingRange.
- **FIX** Fixed unintuitive behavior of regExpCaseSensitive overriding individual RegExp settings.
- **FIX** Cached combined regex in RichTextController to improve performance.
- **CHORE** Improved error handling for invalid targetMatches and composingRange.

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

