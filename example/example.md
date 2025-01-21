# RichTextController Example

The `RichTextController` package allows you to easily highlight and style specific text patterns or strings in a `TextField` or `TextFormField` using `MatchTargetItem`. Here's how you can get started:

---

## Basic Usage

Below is a simple example of using `RichTextController` with both string and regex-based matches:

```dart
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:rich_text_controller/models/match_target_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RichTextExample(),
    );
  }
}

class RichTextExample extends StatelessWidget {
  RichTextExample({Key? key}) : super(key: key);

  // Define your target matches
  final targetMatches = [
    MatchTargetItem.text(
      'highlight', // Match exact text
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    MatchTargetItem.pattern(
      r'\bFlutter\b', // Match the word "Flutter"
      style: const TextStyle(color: Colors.green),
      onTap: (match) {
        print('Tapped on match: $match');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RichTextController Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: RichTextController(
            text: 'Type "highlight" or "Flutter" here!',
            targetMatches: targetMatches,
            onMatch: (matches) {
              print('Matched: $matches');
            },
          ),
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Start typing...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
```

---

## Key Features Highlighted in the Example

1. **Matching Exact Text**  
   Use `MatchTargetItem.text` to match specific strings like `"highlight"` and style them.  

2. **Regex Matching**  
   Use `MatchTargetItem.pattern` to match patterns (e.g., `\bFlutter\b`) and apply styles.  

3. **Interactive Callbacks**  
   Add `onTap` for actions triggered when users tap on matches.  

4. **Dynamic Text Styling**  
   The styles are applied dynamically as the user types.

---

Feel free to explore additional features like dynamic updates to `targetMatches` using `updateTargetMatches` or handling IME composition for complex text inputs.

That's it! 🎉  
Check the documentation for more advanced use cases and configurations.
