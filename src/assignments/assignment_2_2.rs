use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "2_2".to_string(),
        "2".to_string(),
        2,
        "Dive!".to_string(),
        Some(1982495697),
        _run,
    );
}

fn _run(data: Vec<String>) -> Option<i32> {
    let position =
        _parse_instructions(data)
            .iter()
            .fold(Position { x: 0, y: 0, aim: 0 }, |pos, inst| {
                match inst.command.as_str() {
                    "forward" => Position {
                        x: pos.x + inst.units,
                        y: pos.y + (pos.aim * inst.units),
                        aim: pos.aim,
                    },
                    "down" => Position {
                        x: pos.x,
                        y: pos.y,
                        aim: pos.aim + inst.units,
                    },
                    "up" => Position {
                        x: pos.x,
                        y: pos.y,
                        aim: pos.aim - inst.units,
                    },
                    _ => pos,
                }
            });

    Some(position.x * position.y)
}

fn _parse_instructions(raw_lines: Vec<String>) -> Vec<Instruction> {
    return raw_lines
        .iter()
        .map(|line| {
            let mut parts = line.split(' ');
            let command = parts.next().unwrap();
            let units = parts.next().unwrap();

            Instruction {
                command: command.to_string(),
                units: units.parse::<i32>().unwrap(),
            }
        })
        .collect();
}

struct Instruction {
    command: String,
    units: i32,
}

struct Position {
    x: i32,
    y: i32,
    aim: i32,
}
