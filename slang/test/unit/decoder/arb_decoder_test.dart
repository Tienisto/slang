import 'dart:convert';

import 'package:slang/src/builder/decoder/arb_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('decode', () {
    test('Should decode single string', () {
      expect(
        _decodeArb({'hello': 'world'}),
        {'hello': 'world'},
      );
    });

    test('Should decode with named parameter', () {
      expect(
        _decodeArb({'hello': 'hello {name}'}),
        {'hello': 'hello {name}'},
      );
    });

    test('Should decode with positional parameter', () {
      expect(
        _decodeArb({'hello': 'hello {0}'}),
        {'hello': 'hello {arg0}'},
      );
    });

    test('Should decode with description', () {
      expect(
        _decodeArb({
          'hello': 'world',
          '@hello': {'description': 'This is a description'},
        }),
        {
          'hello': 'world',
          '@hello': 'This is a description',
        },
      );
    });

    test('Should decode with parameter type', () {
      expect(
        _decodeArb({
          'age': 'You are {age} years old',
          '@age': {
            'placeholders': {
              'age': {
                'type': 'int',
              },
            },
          }
        }),
        {
          'age': 'You are {age: int} years old',
        },
      );
    });

    test('Should decode with DateFormat', () {
      expect(
        _decodeArb({
          'today': 'Today is {date}',
          '@today': {
            'placeholders': {
              'date': {
                'type': 'DateTime',
                'format': 'yMd',
              },
            },
          }
        }),
        {
          'today': 'Today is {date: DateFormat("yMd")}',
        },
      );
    });

    test('Should decode with NumberFormat', () {
      expect(
        _decodeArb({
          'price': 'Price: {price}',
          '@price': {
            'placeholders': {
              'price': {
                'type': 'num',
                'format': 'currency',
              },
            },
          }
        }),
        {
          'price': 'Price: {price: NumberFormat.currency}',
        },
      );
    });

    test('Should decode with NumberFormat and parameters', () {
      expect(
        _decodeArb({
          'price': 'Price: {price}',
          '@price': {
            'placeholders': {
              'price': {
                'type': 'num',
                'format': 'currency',
                'optionalParameters': {
                  'symbol': '€',
                  'decimalDigits': 4,
                },
              },
            },
          }
        }),
        {
          'price':
              "Price: {price: NumberFormat.currency(symbol: '€', decimalDigits: 4)}",
        },
      );
    });

    test('Should decode plural string identifiers', () {
      expect(
        _decodeArb({
          'inboxCount':
              '{count, plural, zero{You have no new messages} one{You have 1 new message} other{You have {count} new messages}}'
        }),
        {
          'inboxCount(plural, param=count)': {
            'zero': 'You have no new messages',
            'one': 'You have 1 new message',
            'other': 'You have {count} new messages',
          },
        },
      );
    });

    test('Should decode plural with number identifiers', () {
      expect(
        _decodeArb({
          'inboxCount':
              '{count, plural, =0{You have no new messages} =1{You have 1 new message} other{You have {count} new messages}}'
        }),
        {
          'inboxCount(plural, param=count)': {
            'zero': 'You have no new messages',
            'one': 'You have 1 new message',
            'other': 'You have {count} new messages',
          },
        },
      );
    });

    test('Should decode plural with spaces between identifiers', () {
      expect(
        _decodeArb({
          'inboxCount': 'You have {count, plural, one  {1 new message} }',
        }),
        {
          'inboxCount__count(plural, param=count)': {
            'one': '1 new message',
          },
          'inboxCount': 'You have @:inboxCount__count',
        },
      );
    });

    test('Should decode custom context', () {
      expect(
        _decodeArb({
          'hello':
              '{gender, select, male{Hello Mr {name}} female{Hello Mrs {name}} other{Hello {name}}}'
        }),
        {
          'hello(context=Gender, param=gender)': {
            'male': 'Hello Mr {name}',
            'female': 'Hello Mrs {name}',
            'other': 'Hello {name}',
          },
        },
      );
    });

    test('Should decode multiple plurals', () {
      expect(
        _decodeArb({
          'inboxCount':
              '{count, plural, zero{You have no new messages} one{You have 1 new message} other{You have {count} new messages}} {appleCount, plural, zero{You have no new apples} one{You have 1 new apple} other{You have {appleCount} new apples}}'
        }),
        {
          'inboxCount__count(plural, param=count)': {
            'zero': 'You have no new messages',
            'one': 'You have 1 new message',
            'other': 'You have {count} new messages',
          },
          'inboxCount__appleCount(plural, param=appleCount)': {
            'zero': 'You have no new apples',
            'one': 'You have 1 new apple',
            'other': 'You have {appleCount} new apples',
          },
          'inboxCount': '@:inboxCount__count @:inboxCount__appleCount',
        },
      );
    });

    test('Should decode multiple plurals with same parameter', () {
      expect(
        _decodeArb({
          'inboxCount':
              '{count, plural, zero{You have no new messages} one{You have 1 new message} other{You have {count} new messages}} {count, plural, zero{You have no new apples} one{You have 1 new apple} other{You have {count} new apples}}'
        }),
        {
          'inboxCount__count(plural, param=count)': {
            'zero': 'You have no new messages',
            'one': 'You have 1 new message',
            'other': 'You have {count} new messages',
          },
          'inboxCount__count2(plural, param=count)': {
            'zero': 'You have no new apples',
            'one': 'You have 1 new apple',
            'other': 'You have {count} new apples',
          },
          'inboxCount': '@:inboxCount__count @:inboxCount__count2',
        },
      );
    });
  });
}

final _decoder = ArbDecoder();

Map<String, dynamic> _decodeArb(Map<String, dynamic> arb) {
  return _decoder.decode(jsonEncode(arb));
}
