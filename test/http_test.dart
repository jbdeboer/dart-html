import 'fixed-unittest.dart';
import 'package:di/di.dart';
import 'dart:async';

/*

it('should do basic request', inject(function($httpBackend, $http) {
$httpBackend.expect('GET', '/url').respond('');
$http({url: '/url', method: 'GET'});
}));

*/
class Expectation {
  String method, url, data;
  Expectation(this.method, this.url);
  respond(data) { this.data = data; }
}

abstract class HttpBackend {
  call(String method, String url);
}

class MockHttpBackend extends HttpBackend {
  List expectations = new List<Expectation>();

  expect(method, url) {
    var expectation = new Expectation(method, url);
    expectations.add(expectation);
    return expectation;
  }

  call(method, url) {
    // get the first expectaction and verify the
    // method and url.
    var expectation = expectations.removeAt(0);
    // TODO: remove that first element.
    assert (method == expectation.method &&
        url == expectation.url);
    print('MockHttpBackend: ${expectation.data}');
    return expectation.data;
  }
}

/*
class HttpPromise {
   Future future = new Future();
   success(fn) {
     future.then()
   }
}
*/


class Http {
  HttpBackend backend;
  Http(HttpBackend this.backend);

  call(String method, String url) =>
    backend.call(method, url);
}



main() {
  var injector = new Injector([
      (new Module())..value(HttpBackend, new MockHttpBackend())]);


  it('should do basic requests', () {
    MockHttpBackend backend = injector.get(HttpBackend);
    Http http = injector.get(Http);

    backend.expect('GET', '/url').respond('DATA');
    // bad example, shouldn't return a string.
    expect(http.call('GET', '/url'), toEqual('DATA'));

    //http.call('GET', '/url').success()
  });




}
