import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rich_text_controller/rich_text_controller.dart';

void main() {
  group('RichTextController', () {
    group(
      "Instance Initialization Test",
      () {
        //t2 - SUT
        late RichTextController _sut;
        //t2 - Setup
        setUp(() {
          _sut = RichTextController(
            text: "initial Text",
            patternMatchMap: {
              RegExp(r'\B#[a-zA-Z0-9]+\b'): const TextStyle(
                color: Colors.red,
                fontSize: 22.0,
              ),
            },
            onMatch: (matches) {
              return 'matched';
            },
            onMatchIndex: (matches) {
              return 'matchedIndex';
            },
            deleteOnBack: true,
            regExpCaseSensitive: false,
            regExpDotAll: true,
            regExpMultiLine: true,
            regExpUnicode: true,
          );
        });
        //t2 - Tests
        test('Should have initial text',
            () => expect(_sut.text, "initial Text"));
        test(
            'Should have initial pattern map',
            () => expect(_sut.patternMatchMap, {
                  RegExp(r'\B#[a-zA-Z0-9]+\b'): const TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                  ),
                }));
        test(
          'Should have initial String map',
          () {
            _sut = RichTextController(
              stringMatchMap: {
                'Hello!': const TextStyle(
                  color: Colors.red,
                  fontSize: 22.0,
                ),
              },
              onMatch: (matches) {},
            );

            expect(_sut.stringMatchMap, {
              'Hello!': const TextStyle(
                color: Colors.red,
                fontSize: 22.0,
              ),
            });
          },
        );
        test('Should have initial onMatch',
            () => expect(_sut.onMatch.call(['match']), 'matched'));
        test('Should have initial onMatchIndex',
            () => expect(_sut.onMatchIndex?.call([{}]), 'matchedIndex'));
        test('Should have initial deleteOnBack',
            () => expect(_sut.deleteOnBack, true));
        test('Should have initial regExpCaseSensitive',
            () => expect(_sut.regExpCaseSensitive, false));
        test('Should have initial regExpDotAll',
            () => expect(_sut.regExpDotAll, true));
        test('Should have initial regExpMultiLine',
            () => expect(_sut.regExpMultiLine, true));
        test('Should have initial regExpUnicode',
            () => expect(_sut.regExpUnicode, true));
        test(
          'Should reproduce assertions',
          () {
            dynamic error;
            try {
              _sut = RichTextController(
                stringMatchMap: {},
                patternMatchMap: {},
                onMatch: (matches) {},
              );
            } catch (e) {
              error = e;
            }
            expect(error != null, true);
          },
        );
      },
    );
    group(
      "Features Test",
      () {
        //t2 - SUT
        late RichTextController _sut;
        //t2 - Setup
        setUp(() {
          _sut = RichTextController(
            text: "initial Text",
            patternMatchMap: {
              RegExp(r'\B#[a-zA-Z0-9]+\b'): const TextStyle(
                color: Colors.red,
                fontSize: 22.0,
              ),
            },
            onMatch: (matches) {
              return 'matched';
            },
            onMatchIndex: (matches) {
              return 'matchedIndex';
            },
            deleteOnBack: true,
            regExpCaseSensitive: false,
            regExpDotAll: true,
            regExpMultiLine: true,
            regExpUnicode: true,
          );
        });
        //t2 - Tests

        test('Setting Text Works', () {
          _sut.text = 'new Text!';
          expect(_sut.text, 'new Text!');
        });
      },
    );
  });
}
