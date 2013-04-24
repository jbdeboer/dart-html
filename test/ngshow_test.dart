import 'fixed-unittest.dart';
import 'dart:async';
import 'dart:collection';
import '../lib/src/ngshow.dart';
import 'package:js/js.dart' as js;



class MockHtmlElement {
  bool hidden = false;  // by default
}

class Scope extends HashMap {
  var handlers = new Map();
  $watch(String expr, handler) {
    assert(expr != null);
    print('watching: $expr');
    handlers[expr] = handler;

  }

  $apply() {
    handlers.forEach((expr, js.Callback handler) {
      print('\$appy: $expr');
      if (expr == 'false') { handler.callback([this, false]); }
      else { handler.callback([this, this[expr]]); }
    });
  }
}

class NgRepeatDirective {
  link(Map scope, element, attr) {
    // parse the expression out of attr.ngRepeat
    // assume we get "todo in todos"
    var lhs = "todo";
    var rhs = "todos";

    // assume todos was an array:
    var parsedRhs = ['buy milk', 'pick up dog'];
    scope[r"$count"] = 2;




/*    return function(scope, iterStartElement, attr){
      var expression = attr.ngRepeat;
      var match = expression.match(/^\s*(.+)\s+in\s+(.*)\s*$/),
lhs, rhs, valueIdent, keyIdent;
if (! match) {
throw Error("Expected ngRepeat in form of '_item_ in _collection_' but got '" +
expression + "'.");
}*/
  }
}

main() {

//  var injector = new Injector([
//      (new Module())..value(HttpBackend, new MockHttpBackend())]);
//

  it('Function.apply works with closures', () {
    var called = false;
    Function.apply((x, [y]) { called = true;}, [2]);
    expect(called, equals(true));
  });


  // old ng-repeat test.
  it('should publish \$count', () {
     var scope = new Map();
     var ngRepeat = new NgRepeatDirective();

     ngRepeat.link(scope, null, null);

     expect(scope[r"$count"], equals(2));

  });

  // ng-show tests
  it('should hide an element', () {
    var scope = new Scope();
    var ngShow = new NgShowDirective();
    var element = new MockHtmlElement();
    ngShow.link(scope, [element], {'ngDartShow': 'false'});

    scope.$apply();
    expect(element.hidden, equals(true));
  });

  it('should hide an element and then show it.', () {
    var scope = new Scope();
    scope["a"] = false;
    var ngShow = new NgShowDirective();
    var element = new MockHtmlElement();
    ngShow.link(scope, [element], {'ngDartShow': 'a'});
    scope.$apply();

    expect(element.hidden, equals(true));
    scope["a"] = true;
    scope.$apply();
    expect(element.hidden, equals(false));

  });
}
