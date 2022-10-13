use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "3".to_string(),
        2,
        "Binary Diagnostic".to_string(),
        None,
        _run,
    );
}

fn _run(_: Vec<String>) -> Option<i32> {
    //TODO: Implement
    None
}
