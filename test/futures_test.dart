import 'dart:async';
import 'dart:math';
import 'fixed-unittest.dart';

main() {
  playWithFutures(bool sometimes) {
    var completer = new Completer();
    var barf;
    Future getFuture() => sometimes ? new Future.sync(() => "of") : completer.future;
    var result = getFuture().then((r) { print("$r ${barf()}"); });
    completer.complete("completer");
    barf = () => "output";
  }

  it('should work sometimes', () {
    playWithFutures(true);
  });

  it('should work other times', () {
    //playWithFutures(false);
  });


  playWithThen(bool sometimes) {
    var completer = new Completer();
    maybeComplete() {
      if (sometimes == true) {
        completer.complete((_){});
        sometimes = null;
      } else if (sometimes == false) {
        sometimes = true;
      }
    }

    var chain = completer.future.then((_) { print("a"); });
    maybeComplete();
    chain.then((_) { print("b");});
    maybeComplete();
    chain.then((_) { print("c");});
    print("end of playsWith");
  }

  it('then should work', () {
    //playWithThen(true);
  });
  it('then should work', () {
    playWithThen(false);
  });


}
