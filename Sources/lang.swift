
public func escapeString(_ s: String) -> String {
  var z = ""
  debugPrint(s, terminator: "", to: &z)
  return z
}

public func inspect(_ o: Any) -> String {
  var z = ""
  debugPrint(o, terminator: "", to: &z)
  return z
}

public func p(_ a: Any...) {
  for e in a {
    debugPrint(e)
  }
}

// printList is like the "puts" command in Ruby.
// printList will check whether the line ends with a new line, and if it does
// not, it will append a new line to it.
//
// Since importing Glibc already imports the "puts" command found in C which
// would conflict with this command, we've given it a unique name instead.
public func printList(_ string: String) {
  // 10 - new line
  if string.isEmpty ||
      string.utf16[string.utf16.count - 1] != 10 {
    print(string)
  } else {
    Stdout.write(string)
  }
}
