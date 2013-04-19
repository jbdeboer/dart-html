library ngrepeat;

import 'package:js/js.dart' as js;

class NgShowDirective {
  link(scope, jquery, attr, [fourth]) {
    var element = jquery[0];
    scope.$watch(attr["ngDartShow"], new js.Callback.many((value, [something, thing2, thing3]) {
      print('Element: $element');
      element.hidden = !value;
    }));
  }
}
