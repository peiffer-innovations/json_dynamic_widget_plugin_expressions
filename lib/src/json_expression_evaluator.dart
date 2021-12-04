import 'package:expressions/expressions.dart';
import 'package:json_dynamic_widget_plugin_expressions/json_dynamic_widget_plugin_expressions.dart';

class JsonExpressionEvaluator extends ExpressionEvaluator {
  const JsonExpressionEvaluator({
    List<MemberAccessor> memberAccessors = const [],
  }) : super(memberAccessors: memberAccessors);

  @override
  dynamic evalCallExpression(
    CallExpression expression,
    Map<String, dynamic> context,
  ) {
    var arguments = [];
    for (var arg in expression.arguments) {
      arguments.add(eval(arg, context));
    }

    dynamic callee = expression.callee;
    dynamic result;
    callee = eval(expression.callee, context);
    if (callee is RegistryFunction) {
      result = Function.apply(callee.executor, null, {
        const Symbol('args'): arguments,
        const Symbol('registry'): callee.registry,
      });
    } else {
      result = Function.apply(callee, arguments);
    }

    return result;
  }
}
