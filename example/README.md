```dart
import 'package:flutter/material.dart';
import 'rich_text_controller/rich_text_controller.dart';

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
RichTextController _controller;

  @override
  void initState() {
      // initialize with your custom regex patterns or Strings and styles
      //* Starting V1.2.0 You also have "String" parameter in default constructor and also added the //"fromValue" Constructor!
      _controller = RichTextController(
          patternMap: {
           //
          //* Returns every Hashtag with red color
          //
          RegExp(r"\B#[a-zA-Z0-9]+\b"):TextStyle(color:Colors.red),
           //
          //* Returns every Mention with blue color and bold style.
          //
          RegExp(r"\B@[a-zA-Z0-9]+\b"):TextStyle(fontWeight: FontWeight.w800 ,color:Colors.blue,),
           //
          //* Returns every word after '!' with yellow color and italic style.
          //
          RegExp(r"\B![a-zA-Z0-9]+\b"):TextStyle(color:Colors.yellow, fontStyle:FontStyle.italic),
         // add as many expressions as you need!
          },
         //* starting v1.2.0
         // Now you have the option to add string Matching!
          stringMap: {
          "String1":TextStyle(color: Colors.red),
          "String2":TextStyle(color: Colors.yellow),
         },
        //! Assertion: Only one of the two matching options can be given at a time!

         //* starting v1.1.0
         //* Now you have an onMatch callback that gives you access to a List<String>
         //* which contains all matched strings
         onMatch: (List<String> matches){
           // Do something with matches.
           //! P.S
           // as long as you're typing, the controller will keep updating the list.
         }

      );
    super.initState();
  }
}
```
