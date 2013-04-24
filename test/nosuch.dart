class B {
  noSuchMethod(x) { print("nosuch ${x.memberName}"); }
}

main() {
  new B().deboer();
}
