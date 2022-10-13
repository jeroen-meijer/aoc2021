use super::Assignment;

pub fn get_assignment() -> Assignment {
    return Assignment::new(
        "4".to_string(),
        2,
        "Giant Squid".to_string(),
        Some(16836),
        _run,
    );
}

type BoardRow = Vec<i32>;
type Board = Vec<BoardRow>;

#[derive(Debug)]
struct BoardWinSets {
    board_index: usize,
    win_sets: Vec<Vec<i32>>,
}

const BOARD_LENGTH: usize = 5;

fn _run(data: Vec<String>) -> Option<i32> {
    let all_drawn_numbers = _collect_drawn_numbers(&data);

    let boards = _create_boards(&data);

    let all_board_win_sets = boards
        .iter()
        .enumerate()
        .map(|(i, board)| _calculate_win_sets_for_board(i, board))
        .collect::<Vec<_>>();

    let mut winning_board_indices: Vec<usize> = vec![];
    let mut last_winning_drawn_numbers: Option<Vec<i32>> = None;

    for i in BOARD_LENGTH..all_drawn_numbers.len() + 1 {
        let current_drawn_numbers = &all_drawn_numbers[0..i];

        let boards_to_check = all_board_win_sets
            .iter()
            .filter(|b| !winning_board_indices.contains(&b.board_index))
            .collect::<Vec<_>>();

        for board in boards_to_check {
            let has_match = board
                .win_sets
                .iter()
                .any(|set| set.iter().all(|num| current_drawn_numbers.contains(num)));

            if has_match {
                winning_board_indices.push(board.board_index);
                last_winning_drawn_numbers = Some(current_drawn_numbers.to_vec());
            }
        }
    }

    if let Some(index) = winning_board_indices.last() {
        let numbers = last_winning_drawn_numbers.unwrap();

        let unmarked_numbers_sum = boards[*index]
            .iter()
            .flatten()
            .filter(|n| !numbers.contains(n))
            .sum::<i32>();

        let last_drawn_number = numbers.last().unwrap();

        return Some(unmarked_numbers_sum * last_drawn_number);
    }

    None
}

fn _collect_drawn_numbers(data: &Vec<String>) -> Vec<i32> {
    return data
        .first()
        .unwrap()
        .split(',')
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<_>>();
}

fn _create_boards(data: &Vec<String>) -> Vec<Board> {
    let processed_data = data.iter().skip(1).filter(|s| !s.trim().is_empty());

    let all_rows = processed_data
        .map(|line| line.trim())
        .map(|line| {
            line.split(' ')
                .filter(|s| !s.is_empty())
                .map(|s| s.parse::<i32>().unwrap())
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    let boards = all_rows
        .chunks(5)
        .map(|board_chunk| board_chunk.to_vec())
        .collect::<Vec<Board>>();

    boards
}

fn _calculate_win_sets_for_board(index: usize, board: &Board) -> BoardWinSets {
    let horizontal_win_sets = board.clone();
    let vertical_win_sets = (0..BOARD_LENGTH)
        .map(|i| board.clone().iter().map(|row| row[i]).collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let win_sets = horizontal_win_sets
        .into_iter()
        .chain(vertical_win_sets)
        .collect::<Vec<_>>();

    return BoardWinSets {
        board_index: index,
        win_sets: win_sets,
    };
}
