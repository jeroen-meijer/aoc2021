use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "3".to_string(),
        1,
        "Binary Diagnostic".to_string(),
        Some(3309596),
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let bit_threshold = data.len() / 2;
    let bit_length = data.first().unwrap().len();
    let mut bit_counts: Vec<usize> = vec![0; bit_length];

    for value in data {
        let chars = value.chars().collect::<Vec<_>>();
        for bit_pos in 0..bit_length {
            let current_char = chars[bit_pos];
            let char_value = if current_char == '0' { 0 } else { 1 };

            bit_counts[bit_pos] = bit_counts[bit_pos] + char_value;
        }
    }

    let most_common_binary = bit_counts
        .iter()
        .map(|amount| if amount > &bit_threshold { '1' } else { '0' })
        .collect::<String>();

    let least_common_binary = bit_counts
        .iter()
        .map(|amount| if amount < &bit_threshold { '1' } else { '0' })
        .collect::<String>();

    let most_common = i32::from_str_radix(most_common_binary.as_str(), 2).unwrap();
    let least_common = i32::from_str_radix(least_common_binary.as_str(), 2).unwrap();

    let result = most_common * least_common;

    Some(result)
}
