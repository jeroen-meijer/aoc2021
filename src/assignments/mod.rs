mod assignment_1_1;
mod assignment_1_2;
mod assignment_2_1;

use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn get_assignments() -> Vec<Assignment> {
    return vec![
        assignment_1_1::get_assignment(),
        assignment_1_2::get_assignment(),
        assignment_2_1::get_assignment(),
    ];
}

pub struct Assignment {
    pub id: String,
    pub day: String,
    pub part: i32,
    pub description: String,
    pub answer: Option<i32>,
    _f: InternalAssignmentCallback,
}

type InternalAssignmentCallback = fn(data: Vec<String>) -> Option<i32>;

impl Assignment {
    pub fn new(
        id: String,
        day: String,
        part: i32,
        description: String,
        answer: Option<i32>,
        run: InternalAssignmentCallback,
    ) -> Assignment {
        return Assignment {
            id,
            day,
            part,
            description,
            answer: answer,
            _f: run,
        };
    }

    pub fn run(&self) -> Result<Option<i32>, String> {
        // Reads the file <id>.txt and returns the contents as a vector of strings.
        let path = format!("src/assignments/assignment_{}.txt", self.id);
        let data = _read_lines(&path)
            .and_then(|lines| lines.collect::<Result<Vec<String>, io::Error>>())
            .map_err(|e| format!("Could not read file at {}\nError: {}", &path, e))?;

        return Ok((self._f)(data));
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
