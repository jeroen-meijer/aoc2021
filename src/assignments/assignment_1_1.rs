use super::Assignment;

pub fn get_assignment() -> Assignment {
    Assignment::new(
        "1".to_string(),
        1,
        "Sonar Sweep".to_string(),
        Some(1655),
        _run,
    )
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

    Some(increases)
}
