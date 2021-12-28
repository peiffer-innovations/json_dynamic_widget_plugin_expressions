import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_expressions/json_dynamic_widget_plugin_expressions.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });

  var navigatorKey = GlobalKey<NavigatorState>();

  var registry = JsonWidgetRegistry.instance;
  JsonExpressionsPlugin.bind(registry);
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
  registry.setValue('x', 3);
  registry.setValue('y', 4);
  registry.setValue('z', 5);

  registry.navigatorKey = navigatorKey;

  var data = JsonWidgetData.fromDynamic(
    json.decode(await rootBundle.loadString('assets/pages/expressions.json')),
  )!;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleWidgetPage(
        data: data,
      ),
      theme: ThemeData.light(),
    ),
  );
}

class ExampleWidgetPage extends StatelessWidget {
  ExampleWidgetPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final JsonWidgetData data;

  @override
  Widget build(BuildContext context) => data.build(context: context);
}
