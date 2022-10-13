mod assignment_1_1;
mod assignment_1_2;
mod assignment_2_1;
mod assignment_2_2;
mod assignment_3_1;
mod assignment_3_2;
mod assignment_4_1;
mod assignment_4_2;
mod assignment_5_1;
mod assignment_5_2;
mod assignment_6_1;
mod assignment_6_2;
mod assignment_7_1;

use std::collections::{HashMap, HashSet};
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn get_assignments() -> Vec<Assignment> {
    let assignments = vec![
        assignment_1_1::get_assignment(),
        assignment_1_2::get_assignment(),
        assignment_2_1::get_assignment(),
        assignment_2_2::get_assignment(),
        assignment_3_1::get_assignment(),
        assignment_3_2::get_assignment(),
        assignment_4_1::get_assignment(),
        assignment_4_2::get_assignment(),
        assignment_5_1::get_assignment(),
        assignment_5_2::get_assignment(),
        assignment_6_1::get_assignment(),
        assignment_6_2::get_assignment(),
        assignment_7_1::get_assignment(),
    ];

    let id_counts = assignments
        .iter()
        .fold(HashMap::<String, u32>::new(), |mut acc, cur| {
            *acc.entry(cur._get_id()).or_insert(0) += 1;
            acc
        });

    let duplicate_entry_ids = id_counts
        .iter()
        .filter(|(_, count)| count > &&1)
        .collect::<HashMap<_, _>>();

    if !duplicate_entry_ids.is_empty() {
        let duplicates_str = duplicate_entry_ids
            .iter()
            .map(|(id, count)| format!("  - Assignment {} shows up {} time(s)", id, count))
            .collect::<Vec<_>>()
            .join("\n");

        panic!("Duplicate assignment IDs were found:\n{}", duplicates_str);
    }

    assignments
}

pub struct Assignment {
    pub day: String,
    pub part: i32,
    pub description: String,
    pub answer: Option<i32>,
    _f: InternalAssignmentCallback,
}

type InternalAssignmentCallback = fn(data: Vec<String>) -> Option<i32>;

impl Assignment {
    pub fn new(
        day: String,
        part: i32,
        description: String,
        answer: Option<i32>,
        run: InternalAssignmentCallback,
    ) -> Assignment {
        return Assignment {
            day,
            part,
            description,
            answer: answer,
            _f: run,
        };
    }

    fn _get_id(&self) -> String {
        format!("{}_{}", self.day, self.part)
    }

    pub fn run(&self) -> Result<Option<i32>, String> {
        // Reads the file <id>.txt and returns the contents as a vector of strings.
        let path = format!("src/assignments/assignment_{}.txt", self._get_id());
        let data = _read_lines(&path)
            .and_then(|lines| lines.collect::<Result<Vec<String>, io::Error>>())
            .map_err(|e| format!("Could not read file at {}\nError: {}", &path, e))?;

        Ok((self._f)(data))
    }
}

// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn _read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
