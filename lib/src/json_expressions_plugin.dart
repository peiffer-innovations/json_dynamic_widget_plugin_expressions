import 'package:expressions/expressions.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_expressions/json_dynamic_widget_plugin_expressions.dart';

class JsonExpressionsPlugin {
  static void bind(JsonWidgetRegistry registry) {
    var evaluator = JsonExpressionEvaluator();

    registry.registerFunction('expression', ({args, required registry}) {
      if (args == null || args.isEmpty) {
        throw Exception('Function [expression] requires at least one arg');
      }
      var context = Map<String, dynamic>.from(registry.values);

      for (var entry in registry.functions.entries) {
        context[entry.key] = RegistryFunction(
          executor: entry.value,
          registry: registry,
        );
      }

      // Since the current parser splits on all commas, this puts the string
      // back together again
      var expression = Expression.parse(args.join(',').trim());

      var result = evaluator.eval(
        expression,
        context,
      );

      return result;
    });
  }
}
