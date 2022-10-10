use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "4_1".to_string(),
        "4".to_string(),
        1,
        "Giant Squid".to_string(),
        None,
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    // let drawn_numbers = data
    //     .to_owned()
    //     .first()
    //     .unwrap()
    //     .split(',')
    //     .collect::<Vec<_>>();

    let boards = data
        .iter()
        .filter(|line| !line.is_empty())
        .map(|line| line.trim())
        .map(|line| line.split(' '))
        .map(|line| line.collect::<Vec<_>>())
        .collect::<Vec<_>>()
        .chunks(5)
        .collect::<Vec<_>>();

    println!("{}", boards.len());

    // for i in 0..boards.len() {
    //     println!("Board {}", i);
    //     let b = boards[i];
    //     for row in b {
    //         println!("{}", row.join(","))
    //     }
    // }
    None
}
