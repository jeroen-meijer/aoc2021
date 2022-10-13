#![allow(dead_code, unused_variables, unreachable_code)]

use std::io::{self, Write};

use chrono::Local;
use stopwatch::Stopwatch;

use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "6".to_string(),
        2,
        "Lanternfish".to_string(),
        Some(379414),
        _run,
    );
}

const DAYS: u16 = 256;

fn _run(data: Vec<String>) -> Option<i32> {
    // This is... horribly inefficient, to say the least.
    // Returning None for now until I can figure out a better way to do this.
    return None;

    // Original implementation
    let mut subjects = data
        .first()
        .unwrap()
        .split(',')
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<_>>();

    let mut sw = Stopwatch::new();

    for i in 0..DAYS {
        sw.start();
        print!(
            "[{:?}] Day {} ({} subjects)",
            Local::now(),
            i,
            subjects.len()
        );
        io::stdout().flush().unwrap();

        let mut new_subjects = 0;

        for i in 0..subjects.len() {
            let s = subjects[i];
            if s == 0 {
                new_subjects += 1;
                subjects[i] = 6;
            } else {
                subjects[i] = s - 1;
            }
        }

        subjects.append(&mut vec![8; new_subjects]);
        sw.stop();

        println!(
            " took {}s (generated {} new subjects)",
            sw.elapsed_ms() as f64 / 1000.0,
            new_subjects,
        );
        sw.reset();
    }

    Some(subjects.len() as i32)
}
