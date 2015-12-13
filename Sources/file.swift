

public class File: CustomStringConvertible {

  var fd: Int32
  let filePath: String

  init(filePath: String, mode: FileOperation = .R) throws {
    fd = Sys.openFile(filePath, operation: mode)
    if (fd == -1) {
      throw FileError.FileException(message: "Failed to open file.")
    }
    self.filePath = filePath
  }

  public static let NEW_LINE = "\n"
  public static let WINDOWS_NEW_LINE = "\r\n"

/*  func puts(v: ) {
    var f = _f;
    if (v is List) {
      var i, len = v.length;
      for (i = 0; i < len; i++) {
        putStringEnsureNewLine(f, v[i]);
      }
    } else if (v is Iterable) {
      for (var e in v) {
        putStringEnsureNewLine(f, e);
      }
    } else {
      write(v is String ? v : v.toString());
    }
  }

  putStringEnsureNewLine(f, s) {
    if (s is! String) {
      s = s.toString();
    }
    Str.withNewLinePreference(s, IO.isWindows, (s, newLineStr) {
      write(s);
      if (newLineStr != null) {
        write(newLineStr);
      }
      });
  }*/

  /*func <<(string: String) -> File {
    write(string)
    return self
  }*/

  public func print(v: String) {
    write(v)
  }

  public func read(maxBytes: Int = -1) throws -> String {
    let a = try doRead(maxBytes < 0 ? length : maxBytes)
    return String.fromCharCodes(a)
  }

  public func readBytes(maxBytes: Int = -1) throws -> [CChar] {
    return try doRead(maxBytes < 0 ? length : maxBytes)
  }

  public func readUInt8(maxBytes: Int = -1) throws -> [UInt8] {
    var a = [UInt8](count: maxBytes, repeatedValue: 0)
    let n = try read(&a, maxBytes: maxBytes)
    if n < maxBytes {
      a = a[0..<n].map { UInt8($0) }
    }
    return a
  }

  public func readLines() throws -> [String] {
    var r: [String] = []
    let a = try readBytes()
    var si = 0
    for i in 0..<a.count {
      if a[i] == 10 {
        r.append(String.fromCharCodes(a, start: si, end: i))
        si = i + 1
      }
    }
    return r
  }

  public func write(string: String) -> Int {
    return Sys.writeString(fd, string: string)
  }

  public func writeBytes(bytes: [CChar]) -> Int {
    return Sys.write(fd, address: bytes, length: bytes.count)
  }

  public func writeUInt8(bytes: [UInt8]) -> Int {
    return Sys.write(fd, address: bytes, length: bytes.count)
  }

  /*func writeBuffer(ByteBuffer buffer, [int offset = 0, int length = -1]) {
    if (length < 0) {
      length = buffer.lengthInBytes;
    }
    MoreSys.write(_fd, buffer, offset, length);
  }*/

  public func flush() {
    // Not implemented yet.
  }

  public func close() {
    if fd != -1 {
      Sys.close(fd)
    }
    fd = -1
  }

  public var isOpen: Bool { return fd != -1 }

  public func read(address: UnsafeMutablePointer<Void>, maxBytes: Int) throws
      -> Int {
    let n = Sys.read(fd, address: address, length: maxBytes)
    if n == -1 {
      try _error("Failed to read from file")
    }
    return n
  }

  func doRead(maxBytes: Int) throws -> [CChar] {
    var a = [CChar](count: maxBytes, repeatedValue: 0)
    let n = try read(&a, maxBytes: maxBytes)
    if n < maxBytes {
      a = a[0..<n].map { CChar($0) }
    }
    return a
  }

  public var position: Int {
    get {
      return Sys.lseek(fd, offset: 0, whence: PosixSys.SEEK_CUR)
    }
    set(value) {
      Sys.lseek(fd, offset: value, whence: PosixSys.SEEK_SET)
    }
  }

  public var length: Int {
    let current = position
    if current == -1 {
      return -1
    } else {
      let end = Sys.lseek(fd, offset: 0, whence: PosixSys.SEEK_END)
      position = current
      return end
    }
  }

  public var path: String { return filePath }

  public static func open(filePath: String, mode: FileOperation = .R,
      fn: ((f: File) -> Void )?) throws -> File {
    let f = try File(filePath: filePath, mode: mode)
    defer {
      f.close()
    }
    if let af = fn {
      af(f: f)
    }
    return f
  }

  //public static exists(filePath: String) -> Bool {
  //  return Sys.stat(filePath) == 0
  //}

  public static func delete(path: String) throws {
    if Sys.unlink(path) == -1 {
      throw FileError.FileException(message: "Failed to delete file.")
    }
  }

  public static func rename(oldPath: String, newPath: String) throws {
    if Sys.rename(oldPath, newPath: newPath) == -1 {
      throw FileError.FileException(message: "Failed to rename the file.")
    }
  }

  func _error(message: String) throws {
    close()
    throw FileError.FileException(message: message)
  }

  public var description: String { return "File(path: \(inspect(path)))" }

}


public enum FileError: ErrorType {
  case FileException(message: String)
}
