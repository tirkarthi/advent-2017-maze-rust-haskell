extern crate time;

use std::fs::File;
use std::io::prelude::*;

fn main() {
    let mut tm = time::now();
    let mut inpt = File::open("xmas5.txt").expect("file not found");
    let mut content = String::new();
    inpt.read_to_string(&mut content).unwrap();
    let mut after = time::now() - tm;
    println!(
        "reading file into bytestring took {} us",
        after.num_microseconds().unwrap()
    );


    tm = time::now();
    let mut kay: [i32; 1058] = [0; 1058]; //Hard coded this to see how fast it could become
    for (x, line) in content.lines().enumerate() {
        if line == "" {
            continue;
        }
        kay[x] = line.parse().unwrap();
    }
    after = time::now() - tm;
    println!(
        "parsing {} lines took {} us",
        kay.len(),
        after.num_microseconds().unwrap()
    );

    tm = time::now();
    let mut counter = 0i64; //Kay is the array containing the maze
    let mut ind = 0i32; //ind is current index
    while ind < kay.len() as i32 {
        counter += 1;
        let i = ind as usize; //temporarary helper
        let curr = kay[i];
        if curr >= 3 {
            kay[i] -= 1;
        } else {
            kay[i] += 1;
        }
        ind += curr;
    }
    after = time::now() - tm;
    println!(
        "{}, is the answer, it took {} ms",
        counter,
        after.num_milliseconds()
    )
}
