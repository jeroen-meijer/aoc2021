use std::collections::HashMap;

use super::Assignment;

pub fn get_assignment() -> Assignment {
    Assignment::new(
        "7".to_string(),
        1,
        "The Treachery of Whales".to_string(),
        Some(352707),
        _run,
    )
}

fn _run(data: Vec<String>) -> Option<i32> {
    let positions = data
        .first()
        .unwrap()
        .split(',')
        .map(|s| s.parse::<u32>().unwrap())
        .collect::<Vec<_>>();

    let max_dist = positions.iter().max().unwrap();
    let all_dist = 0..(max_dist + 1);

    let all_distance_fuel_usages = all_dist.fold(HashMap::<u32, Vec<u32>>::new(), |mut acc, d| {
        let fuel_usages = positions.iter().map(|p| p.abs_diff(d)).collect::<Vec<_>>();

        acc.insert(d, fuel_usages);
        acc
    });

    let (_, min_fuel_usage) = all_distance_fuel_usages
        .iter()
        .map(|(d, fuel_usages)| {
            let summed_fuel_usage = fuel_usages.iter().sum::<u32>();

            (d, summed_fuel_usage)
        })
        .min_by(|(_, a), (_, b)| a.cmp(b))
        .unwrap();

    Some(min_fuel_usage as i32)
}
