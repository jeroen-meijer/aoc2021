use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "1_1".to_string(),
        "1".to_string(),
        1,
        "Sonar Sweep".to_string(),
        None,
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let depths = data
        .iter()
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<_>>();

    let mut increases = 0;
    for i in 1..depths.len() {
        let depth = depths[i];
        let last_depth = depths[i - 1];
        if depth > last_depth {
            increases += 1;
        }
    }

    return Some(increases);
}