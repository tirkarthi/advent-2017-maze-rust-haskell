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
    reading file into bytestring took 225.37 us
    parsing 1058 lines took 58.80 us
    25608482, is the answer, it took 98.74 ms

## Haskell analysis

The Haskell code is a more or less direct translation of the Rust
code. Some comments:

Using ST to deal with the vector shaves off 10ms from the answer, but
this version is more direct.

You have to remember to annotate your integers, otherwise

``` haskell
while !(counter::Int) !(ind::Int) = do
```

without the annotations is inferred as an `Integer`, which is about 5x
slower.

Using the `mapM (\(x, line) -> ...) (zip [0..] (S.lines ...))` pattern
is less efficient than the more direct `mapLinesM`. Adding `INLINE`
also speeds it up, fairly obviously.

Overall the programs run in the same order of magnitude in speed.

## Haskell runtime stats

           313,336 bytes allocated in the heap
                64 bytes copied during GC
           156,432 bytes maximum residency (1 sample(s))
            81,136 bytes maximum slop
                 5 MB total memory in use (0 MB lost due to fragmentation)

                                       Tot time (elapsed)  Avg pause  Max pause
    Gen  0         0 colls,     0 par    0.000s   0.000s     0.0000s    0.0000s
    Gen  1         1 colls,     0 par    0.000s   0.000s     0.0004s    0.0004s

    Parallel GC work balance: nan% (serial 0%, perfect 100%)

    TASKS: 18 (1 bound, 17 peak workers (17 total), using -N8)

    SPARKS: 0 (0 converted, 0 overflowed, 0 dud, 0 GC'd, 0 fizzled)

    INIT    time    0.000s  (  0.002s elapsed)
    MUT     time    0.098s  (  0.098s elapsed)
    GC      time    0.000s  (  0.000s elapsed)
    EXIT    time    0.001s  (  0.001s elapsed)
    Total   time    0.132s  (  0.102s elapsed)

    Alloc rate    3,206,500 bytes per MUT second

    Productivity  99.5% of total user, 97.3% of total elapsed
