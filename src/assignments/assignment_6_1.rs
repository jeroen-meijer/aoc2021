use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "6_1".to_string(),
        "6".to_string(),
        1,
        "Lanternfish".to_string(),
        Some(379414),
        _run,
    );
}

const DAYS: u16 = 80;

fn _run(data: Vec<String>) -> Option<i32> {
    let mut subjects = data
        .first()
        .unwrap()
        .split(',')
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<_>>();

    for _ in 0..DAYS {
        let mut new_subjects = 0;

        subjects = subjects
            .iter()
            .map(|x| {
                if x == &0 {
                    new_subjects += 1;
                    return 6;
                } else {
                    return x - 1;
                }
            })
            .collect::<Vec<_>>();

        subjects.append(&mut vec![8; new_subjects])
    }

    Some(subjects.len() as i32)
}
