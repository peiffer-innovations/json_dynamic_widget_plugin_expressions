import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_expressions/json_dynamic_widget_plugin_expressions.dart';
import 'package:logging/logging.dart';

void main() {
  group('args', () {
    var registry = JsonWidgetRegistry.instance;
    JsonExpressionsPlugin.bind(registry);

    test('dynamic args', () {
      registry = registry.copyWith();
      registry.registerFunction(
        'add',
        ({args, required registry}) => args![0] + args[1],
      );
      registry.registerFunction(
        'subtract',
        ({args, required registry}) => args![0] - args[1],
      );

      expect(
        registry.processDynamicArgs('##expression(add(1, 2))##').values,
        3,
      );
      expect(
        registry
            .processDynamicArgs(
              '##expression(add(subtract(2, 1), add(1, 1)))##',
            )
            .values,
        3,
      );
    });

    test('mixed variables', () {
      registry = registry.copyWith();
      registry.registerFunction(
        'add',
        ({args, required registry}) => args![0] + args[1],
      );
      registry.registerFunction(
        'subtract',
        ({args, required registry}) => args![0] - args[1],
      );
      registry.setValue('one', 1);
      registry.setValue('two', 2);

      expect(
        registry.processDynamicArgs('##expression(add(one, two))##').values,
        3,
      );
      expect(
        registry
            .processDynamicArgs(
              '##expression(add(subtract(two, one), add(one, one)))##',
            )
            .values,
        3,
      );
    });
  });
  group('registry functions', () {
    var registry = JsonWidgetRegistry.instance;
    JsonExpressionsPlugin.bind(registry);

    test('math', () {
      registry = registry.copyWith();
      registry.registerFunction(
        'add',
        ({args, required registry}) => args![0] + args[1],
      );
      registry.registerFunction(
        'subtract',
        ({args, required registry}) => args![0] - args[1],
      );

      expect(registry.execute('expression', ['add(1, 2)']), 3);
      expect(
        registry.execute(
          'expression',
          ['add(subtract(2, 1), add(1, 1))'],
        ),
        3,
      );

      Logger.root.clearListeners();
      Logger.root.level = Level.ALL;
      dynamic logged;
      Logger.root.onRecord.listen((record) {
        logged = record.message;
      });
      registry.execute(
        'expression',
        ['log(add(subtract(2, 1), add(1, 1)))'],
      );
      expect(
        logged,
        '3',
      );
    });

    test('log', () {
      registry = registry.copyWith();
      Logger.root.clearListeners();
      Logger.root.level = Level.ALL;

      var message = 'hfjkdsahfadskjhfasdjk';
      var found = false;
      Logger.root.onRecord.listen((record) {
        if (record.message == message) {
          found = true;
        }
      });

      registry.execute('expression', ['log("$message")']);
      expect(found, true);
    });
  });

  group('evaluation', () {
    var registry = JsonWidgetRegistry.instance;
    JsonExpressionsPlugin.bind(registry);

    test('math and logical expressions', () {
      registry = registry.copyWith(
        values: {
          'x': 3,
          'y': 4,
          'z': 5,
        },
      );
      var expressions = {
        '1+2': 3,
        '-1+2': 1,
        '1+4-5%2*3': 2,
        'x*x+y*y==z*z': true
      };

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });
    test('index expressions', () {
      registry = registry.copyWith(values: {
        'l': [1, 2, 3],
        'm': {
          'x': 3,
          'y': 4,
          'z': 5,
          's': [null]
        }
      });
      var expressions = {'l[1]': 2, "m['z']": 5, "m['s'][0]": null};

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });
    test('call expressions', () {
      registry = registry.copyWith(
        values: {
          'sqrt': sqrt,
          'x': 3,
          'y': 4,
          'z': 5,
        },
      );
      registry.registerFunctions(
        {
          'sayHi': ({
            required List<dynamic>? args,
            required JsonWidgetRegistry registry,
          }) =>
              'hi',
        },
      );

      var expressions = {'sqrt(x*x+y*y)': 5, 'sayHi()': 'hi'};

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });

    test('conditional expressions', () {
      registry = registry.copyWith(
        values: {'this': [], 'other': {}},
      );
      var expressions = {"this==other ? 'same' : 'different'": 'different'};

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });

    test('array expression', () {
      registry.copyWith();
      var expressions = {
        '[1,2,3]': [1, 2, 3]
      };

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });

    test('map expression', () {
      registry.copyWith();
      var expressions = {
        '{"hello": "world"}': {'hello': 'world'}
      };

      for (var entry in expressions.entries) {
        expect(
          registry.execute('expression', [entry.key]),
          entry.value,
        );
      }
    });
  });
}
