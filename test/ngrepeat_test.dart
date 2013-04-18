import 'fixed-unittest.dart';
import 'package:di/di.dart';
import 'dart:async';


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

  it('should publish \$count', () {
     var scope = new Map();
     var ngRepeat = new NgRepeatDirective();

     ngRepeat.link(scope, null, null);

     expect(scope[r"$count"], equals(2));

  });
}
