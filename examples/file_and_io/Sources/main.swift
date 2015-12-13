
import Glibc
import Sua
import CSua

func gusto() throws {

p("let's go")

let fd = Sys.openFile("/home/dewd/t_/sample.txt")

defer {
  Sys.close(fd)
}

p("fd", fd)

var z = [CChar](count: 1024, repeatedValue: 0)

Sys.read(fd, address: &z, length: 1023)

p(z)

p(String.fromCString(&z) ?? "")

let range = z[2..<4]

p(range)

var b = [CChar](range)

b.append(0)

p(b)

p(String.fromCString(&b) ?? "")

p(String.fromCharCodes(z))

p(String.fromCharCodes(z, start: 2, end: 4))

p(String.fromCharCodes(z, start: 2))

p(String.fromCharCodes(z, start: 3, end: -1))

let a: [CChar] = [72, 101, 108, 108, 111]

print(String.fromCharCodes(a))
print(String.fromCharCodes(a, start: 1, end: 3))

p(PosixSys.SEEK_SET)

p(Sys.lseek(fd, offset: 0, whence: PosixSys.SEEK_END))

p(Sys.rename("/home/dewd/t_/aaa.txt", newPath: "/home/dewd/t_/bbb.txt"))

p(Sys.unlink("/home/dewd/t_/yuyu.txt"))

p(Sys.cwd)

let wfd = Sys.openFile("/home/dewd/t_/newspaper.txt", operation: .W)

defer {
  Sys.close(wfd)
}

var sample = Array("sayugara".utf8)

p(Sys.write(wfd, address: &sample, length: sample.count))

p(Sys.writeString(wfd, string: "hello"))

try File.open("/home/dewd/t_/sample.txt", mode: .R) { f in p(f) }

try File.open("/home/dewd/t_/sample.txt", mode: .R) { f in
  p(try! f.readLines())
}

try File.open("/home/dewd/t_/sample.txt", mode: .R) { f in p(f.length) }

try File.open("/home/dewd/t_/nope_new.txt", mode: .W) { f in
  f.write("Heart Swift\n")
}

try File.open("/home/dewd/t_/nope_new.txt", mode: .R) { f in
  p(try! f.readBytes())
}

try File.open("/home/dewd/t_/nope_new.txt", mode: .R) { f in p(try! f.read()) }

p(try! IO.readLines("/home/dewd/t_/sample.txt"))

p(try IO.writeBytes("/home/dewd/t_/many_tries.txt", bytes: a))

p(Dir.pwd)

//p(try! IO.readLines("/home/dewd/repo/github/sua_swift/.build/debug/Suaa"))

p(try! IO.readBytes("/home/dewd/t_/swift_playground/a.out"))

let jug: [UInt8] = [255, 244, 50, 120, 0]

p(try IO.writeUInt8("/home/dewd/t_/byte_depot.txt", bytes: jug))

}

for i in 0..<1000 {
  p("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii \(i)")
  try gusto()
  IO.sleep(0.05)
}
