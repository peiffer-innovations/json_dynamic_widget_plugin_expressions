import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class RegistryFunction {
  RegistryFunction({
    required this.executor,
    required this.registry,
  });

  final JsonWidgetFunction executor;
  final JsonWidgetRegistry registry;
}
