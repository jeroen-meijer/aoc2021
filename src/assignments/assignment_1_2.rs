use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "1_2".to_string(),
        "1".to_string(),
        2,
        "Sonar Sweep".to_string(),
        Some(1683),
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let depths = data
        .iter()
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<_>>();

    let depth_windows = _create_windows(depths, 3);
    let summed_windows = depth_windows
        .iter()
        .map(|window| window.iter().sum())
        .collect::<Vec<i32>>();

    let mut increases = 0;
    for i in 1..summed_windows.len() {
        let depth = summed_windows[i];
        let last_depth = summed_windows[i - 1];
        if depth > last_depth {
            increases += 1;
        }
    }

    Some(increases)
}

fn _create_windows(list: Vec<i32>, window_size: usize) -> Vec<Vec<i32>> {
    assert_ne!(window_size, 0, "window_size cannot be 0");

    if list.len() < window_size {
        return vec![list];
    }

    let mut windows: Vec<Vec<i32>> = vec![];

    for i in 0..(list.len() - window_size + 1) {
        let end_index = i + window_size;
        let window = list[i..end_index].to_vec();
        windows.push(window)
    }

    windows
}
