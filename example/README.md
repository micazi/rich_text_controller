```dart
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichText Controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RichTextControllerDemo(),
    );
  }
}

class RichTextControllerDemo extends StatefulWidget {
  @override
  _RichTextControllerDemoState createState() => _RichTextControllerDemoState();
}

class _RichTextControllerDemoState extends State<RichTextControllerDemo> {

// Add a controller
  late RichTextController _controller;

  @override
  void initState() {
    // initialize with your custom regex patterns or Strings and styles
    //* Starting V1.2.0 You also have "text" parameter in default constructor !
    _controller = RichTextController(
      targetMatches: [
        MatchTargetItem(
            text: 'coco',
            style: TextStyle(
              color: Colors.blue,
              backgroundColor: Colors.green,
            ),
            allowInlineMatching: true,
            onTap: (){
              print('tap coco');
            }
        ),
        MatchTargetItem(
            text: 'bobo',
            style: TextStyle(
              color: Colors.blue,
              backgroundColor: Colors.green,
            ),
            allowInlineMatching: true,
            onTap: (){
              print('tap bobo');
            }
        ),
        MatchTargetItem(
          regex: RegExp(r"\B![a-zA-Z0-9]+\b"),
          style: TextStyle(
            color: Colors.yellow,
            fontStyle: FontStyle.italic,
          ),
          allowInlineMatching: true,
        ),
      ],
      //* starting v1.1.0
      //* Now you have an onMatch callback that gives you access to a List<String>
      //* which contains all matched strings
      onMatch: (List<String> matches){
        // print("onMatch--->");
        // print(matches[0]);
      },
      onMatchIndex:(List<Map<String, List<int>>> list){
        // print("onMatchIndex--->");
        // print(list[0]);
      },
      deleteOnBack: true,
      // You can control the [RegExp] options used:
      regExpUnicode: true,

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'write something',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 13),
        maxLength: 2000,
        maxLines: 5,
      ),
    );
  }
}
```
