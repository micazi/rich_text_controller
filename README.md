# rich_text_controller

An extended text editing controller that supports different inline styles for custom regex.

## Getting Started

### 1. Depend on it

Add this to your package's pubspec.yaml file:

```
dependencies:
  rich_text_controller: [latest version]
```

### 2. Install it

```
$ flutter pub get
```

### 3. Import it

```dart
import'rich_text_controller/rich_text_controller.dart';
```

## Example

![](lib/demo.gif)

See Example page for example code.

## Usage

| Property                                           | Description                                               | Default   |
| -------------------------------------------------- | --------------------------------------------------------- | --------- |
| **Map<RegExp, TextStyle>** patternMatchMap         | Map to match a certain RegExp pattern with a custom style | **--**    |
| **Map<String, TextStyle>** stringMatchMap          | Map to match a certain word with a custom style           | **--**    |
| **@required Function(List<String> match)** onMatch | Void Callback for matched content                         | **--**    |
| **bool** deleteOnBack                              | delete the last matched content on backspace or not       | **false** |
| **bool** regExpCaseSensitive                       | control the caseSensitive parameter of the used [RegExp]  | **true** |
| **bool** regExpDotAll                              | control the dotAll parameter of the used [RegExp]         | **false** |
| **bool** regExpMultiLine                           | control the multiLine parameter of the used [RegExp]      | **false** |
| **bool** regExpUnicode                             | control the unicode parameter of the used [RegExp]        | **false** |

### Assertions

- Must not add both patternMatchMap and stringMatchMap, only one of them.

## Contributing

Contributing is more than welcomed on any of my packages/plugins.
I will try to keep adding suggested features as i go.

**Current list of contributors:**

- EriKWDev
- avatarnguyen

## Versioning

- **V1.0.0** - First Release.
- **V1.0.1** - Added Example.
- **V1.1.0** - Added onMatch Callback.
- **V1.2.0** - Resolved Issues + added String-Matching.
- **V1.3.0** - Resolved Issues + added Null safety.
- **V1.4.0** - Resolved Issues + added deleteOnBack functionality.

## Authors

**Michael Aziz** - [Github](https://github.com/micwaziz)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
