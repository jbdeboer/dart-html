import 'package:js/js.dart' as js;
import 'dart:html';
import '../lib/src/ngrepeat.dart';

main() {
 js.scoped(() {
    var showDirective = new NgShowDirective();

    var directiveFactory = new js.Callback.many(() {
      return js.map({
        "link": new js.Callback.many(showDirective.link)
      });
    });

    js.context.angular.module('darty', js.array([])).directive(js.map({"ngDartShow": directiveFactory}));

    js.context.angular.bootstrap(js.context.document, js.array(['darty']));

  });
}