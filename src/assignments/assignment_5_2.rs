use std::collections::HashMap;

use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "5_2".to_string(),
        "5".to_string(),
        2,
        "Hydrothermal Venture".to_string(),
        Some(21698),
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let axis_lines = data.iter().map(_parse_line);

    let mut pos_map = HashMap::<Pos, usize>::new();

    for line in axis_lines {
        let positions = _interpolate_segment(line);

        for pos in positions {
            let initial_count = pos_map.get(&pos).unwrap_or(&0);
            pos_map.insert(pos, initial_count + 1);
        }
    }

    return Some(pos_map.values().filter(|x| x > &&1).count() as i32);
}

fn _parse_line(data: &String) -> Line {
    let parts = data.split("->").map(|p| p.trim());
    let positions = parts
        .map(|p| {
            let coords = p
                .split(',')
                .map(|n| n.parse::<usize>().unwrap())
                .collect::<Vec<_>>();
            Pos {
                x: *coords.first().unwrap(),
                y: *coords.last().unwrap(),
            }
        })
        .collect::<Vec<_>>();

    Line {
        start: *positions.first().unwrap(),
        end: *positions.last().unwrap(),
    }
}

fn _interpolate_segment(line: Line) -> Vec<Pos> {
    let has_x_diff = line.start.x != line.end.x;
    let has_y_diff = line.start.y != line.end.y;

    let is_diagonal = has_x_diff && has_y_diff;

    let x_values = _get_range(line.start.x, line.end.x);
    let y_values = _get_range(line.start.y, line.end.y);

    if is_diagonal {
        (0..x_values.len())
            .map(|i| Pos {
                x: x_values[i],
                y: y_values[i],
            })
            .collect::<Vec<_>>()
    } else if has_x_diff {
        x_values
            .iter()
            .map(|x| Pos {
                x: *x,
                y: line.start.y,
            })
            .collect::<Vec<_>>()
    } else {
        y_values
            .iter()
            .map(|y| Pos {
                x: line.start.x,
                y: *y,
            })
            .collect::<Vec<_>>()
    }
}

fn _get_range(a: usize, b: usize) -> Vec<usize> {
    if a > b {
        return (b..a + 1).rev().collect::<Vec<_>>();
    } else {
        return (a..(b + 1)).collect::<Vec<_>>();
    }
}

#[derive(Clone, Copy, Debug)]
struct Line {
    start: Pos,
    end: Pos,
}

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
struct Pos {
    x: usize,
    y: usize,
}
