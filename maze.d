import std.file;
import std.conv;
import std.datetime;
import std.range;
import std.stdio;

void main() {
  auto f = File("xmas5.txt");

  int[1058] kay = 0;
  auto tm = Clock.currTime();
  foreach(x, line; f.byLine().enumerate()) {
    if(line == ""){
      continue;
    }
    kay[x] = to!int(line);
  }
  auto after = Clock.currTime();
  auto duration = after - tm;
  writeln("parsing file took ", duration.total!"usecs", " us");
  tm = Clock.currTime();
  ulong counter = 0;
  ulong ind = 0;
  while(ind < kay.length && ind >= 0){
    counter += 1;
    auto curr = kay[ind];
    if(curr >= 3){
	kay[ind] -= 1;
    } else {
      kay[ind] += 1;
    }
    ind += curr;
  }
  after = Clock.currTime();
  duration = after - tm;
  writeln(counter, " is the answer, it took ", duration.total!"msecs", " ms");
}

/*

➜  D ldc -03 maze.d
➜  D time ./maze
parsing file took 284 us
25608482 is the answer, it took 69 ms
./maze  0.07s user 0.00s system 94% cpu 0.080 total

*/
