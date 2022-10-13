use std::{
    cmp::{max, min},
    collections::HashMap,
};

use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "5".to_string(),
        1,
        "Hydrothermal Venture".to_string(),
        Some(5294),
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let axis_lines = data
        .iter()
        .map(_parse_line)
        .filter(|line| line.start.x == line.end.x || line.start.y == line.end.y);

    let mut pos_map = HashMap::<Pos, usize>::new();

    for line in axis_lines {
        let positions = _interpolate_segment(line);

        for pos in positions {
            let initial_count = pos_map.get(&pos).unwrap_or(&0);
            pos_map.insert(pos, initial_count + 1);
        }
    }

    Some(pos_map.values().filter(|x| x > &&1).count() as i32)
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
    if line.start.x != line.end.x {
        let x_min = min(line.start.x, line.end.x);
        let x_max = max(line.start.x, line.end.x);

        let x_values = x_min..(x_max + 1);

        x_values
            .map(|x| Pos { x, y: line.start.y })
            .collect::<Vec<_>>()
    } else {
        let y_min = min(line.start.y, line.end.y);
        let y_max = max(line.start.y, line.end.y);

        let y_values = y_min..(y_max + 1);

        y_values
            .map(|y| Pos { x: line.start.x, y })
            .collect::<Vec<_>>()
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
