use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "2_1".to_string(),
        "2".to_string(),
        1,
        "Dive!".to_string(),
        None,
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    None
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

struct Position {}
