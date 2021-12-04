# json_dynamic_widget_expressions

## Table of Contents

* [Live Example](#live-example)
* [Introduction](#introduction)
* [Using the Plugin](#using-the-plugin)


## Live Example

* [Web](https://peiffer-innovations.github.io/json_dynamic_widget_plugin_expressions/web/index.html#/)


## Introduction

Plugin to the [JSON Dynamic Widget](https://peiffer-innovations.github.io/json_dynamic_widget) to provide expressions support utilizing the fantastic [expressions](https://pub.dev/packages/expressions) package.


## Using the Plugin

```dart
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_expressions/json_dynamic_widget_plugin_expressions.dart';


void main() {
  // Ensure Flutter's binding is complete
  WidgetsFlutterBinding.ensureInitialized();

  // ...

  // Get an instance of the registry
  var registry = JsonWidgetRegistry.instance;

  // Bind the plugin to the registry.  This is necessary for the registry to
  // find the function provided by the plugin
  JsonExpressionsPlugin.bind(registry);

  // ...
}

```

Once you have bound the plugin, you the `expression` function will be exposed.  When using the `expression` function, you need to fully use the syntax from the [expressions](https://pub.dev/packages/expressions).  All variables and functions from the registry will be exposed to that syntax, but it differs from the syntax of the functions and variables from `JsonDynamicWidget`.

For instance, you can do the following...

```dart
registry.setValue('x', 2);
registry.setValue('y', 4);
registry.registerFunction(
  'add',
  ({args, required registry}) => args![0] + args[1],
);
```

And then the result of this JSON:
```
{
  "type": "text",
  "args": {
    "text": "##expression(add(x+y))##
  }
}
```

... will result in `6` being printed out.