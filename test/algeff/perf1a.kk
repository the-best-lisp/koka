import std/date

function timer(f) {
  val t0 = now().time
  val adjust = now().time - t0
  println("start")
  val start = now().time
  val x = f()
  val end = now().time
  println("ended in " + (end - start - adjust).show + "ms")
  x
}


function fib(n) {
  if (n<=1) then 1 else fib(n - 1) + fib(n - 2);
}

function comp() { 
  fib(5)
}

effect state<s> {
  get()      : s;
  put(i : s) : ()
}
 
function count() {
  comp()
  val i = get()
  if (i == 0) then i else {
    put(i - 1)
    count()
  }
}

function testH(i0) {
  handle(count)(i=i0) {
    return x -> x
    get()    -> resume(i,i)
    put(j)   -> resume(j,())
  }
}

effect linear state1<s> {
  get1()    : s;
  put1(i:s) : ()
}

function count1() {
  comp();
  val i = get1()
  if (i == 0) then i else {
    put1(i - 1)
    count1()
  }
}

function testH1(i0) {
  handle(count1)(i=i0) {
    return x -> x
    get1()   -> resume(i,i)
    put1(j)  -> resume(j,())
  }
}

function testD(i) {
  comp();
  if (i==0) then i else testD(i - 1)
}

val n = 5000000
function main() {
  timer({testD(n)}).show
  timer({testH1(n)}).show
  timer({testH(n)}).show
}