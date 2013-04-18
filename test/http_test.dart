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

  MockHttpPromise call(method, url) {
    // get the first expectaction and verify the
    // method and url.
    var expectation = expectations.removeAt(0);
    // TODO: remove that first element.
    assert (method == expectation.method &&
        url == expectation.url);
    print('MockHttpBackend: ${expectation.data}');
    return new MockHttpPromise(new HttpResponse(expectation.data, 200));
  }
}


class HttpResponse {
  int status;
  String data;
  Map<String, Object> headers;

  HttpResponse(this.data, this.status, [this.headers]);
}

class HttpPromise {
   Completer successCompleter = new Completer<HttpResponse>();
   Future future;

   HttpPromise() {
     future = this.successCompleter.future;
   }
   success(fn(String, int)) {
     future.then((resp) => fn(resp.data, resp.status));
   }

   then(fn) {
     return future.then(fn);
   }
}

class MockHttpPromise extends HttpPromise {
  MockHttpPromise(data) : super() {
    successCompleter.complete(data);
  }
}



class Http {
  HttpBackend backend;
  Http(HttpBackend this.backend);

  var responseInterceptors = new List<Function>();

  HttpPromise call(String method, String url, [Map<String, Object> params]) {
    var promise = backend.call(method, url);
    for(var ri in responseInterceptors) {
      promise.future = promise.future.then((resp) { ri(resp); return resp; });
    }
    return promise;
  }
}



main() {

  var injector = new Injector([
      (new Module())..value(HttpBackend, new MockHttpBackend())]);
*/


  it('should do basic requests', () {
//    MockHttpBackend backend = injector.get(HttpBackend);
//    Http http = injector.get(Http);

    MockHttpBackend backend = new MockHttpBackend();
    Http http = new Http(backend);

    backend.expect('GET', '/url').respond('DATA');

    var successHandler = expectAsync2((String data, int status) {
      expect(data, equals('DATA'));
      expect(status, equals(200));
    });

    http.call('GET', '/url').success(successHandler);
  });

  it ('should allow access to the HttpResponse', () {
    MockHttpBackend backend = new MockHttpBackend();
    Http http = new Http(backend);

    backend.expect('GET', '/url').respond('DATA');

    var successHandler = expectAsync1((HttpResponse resp) {
      expect(resp.data, equals('DATA'));
      expect(resp.status, equals(200));
    });

    http.call('GET', '/url').then(successHandler);
  });

  it('should support response interceptors', () {
    MockHttpBackend backend = new MockHttpBackend();
    Http http = new Http(backend);
    http.responseInterceptors.add((resp) { resp.data = "!${resp.data}";});

    backend.expect('GET', '/url').respond('DATA');

    var successHandler = expectAsync1((HttpResponse resp) {
      expect(resp.data, equals('!DATA'));
      expect(resp.status, equals(200));
    });

    http.call('GET', '/url').then(successHandler);
  });




}
