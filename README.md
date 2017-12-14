# Day 5 of Advent of Code 2017

http://adventofcode.com/2017/day/5

Haskell compared with Rust

## How to run

Rust

    $ cargo run -q
    reading file into bytestring took 531 us
    parsing 1058 lines took 25 us
    25608482, is the answer, it took 117 ms

Haskell

    $ stack build --verbosity silent && stack exec haskell
    reading file into bytestring took 209.70 us
    parsing 1058 lines took 53.88 us
    25608482, is the answer, it took 101.71 ms
