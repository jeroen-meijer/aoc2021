mod assignments;
mod helpers;
use assignments::get_assignments;

fn throw_invalid_assignment_number_error() -> ! {
    println!("Invalid &assignment number.");
    println!(
        "Usage: src/main.rs <assignment_number[1 through {}]>",
        get_assignments().len()
    );
    std::process::exit(1);
}

fn main() {
    let args = std::env::args().collect::<Vec<_>>();

    if args.len() != 2 {
        throw_invalid_assignment_number_error();
    }

    let assignment_number = match args[1].parse::<i32>() {
        Ok(n) => n,
        Err(_) => throw_invalid_assignment_number_error(),
    };

    let assignments = get_assignments();
    let assignment = match assignments.get(assignment_number as usize - 1) {
        Some(a) => a,
        None => throw_invalid_assignment_number_error(),
    };

    println!(
        "Running assignment Day {} Part {}: {}",
        assignment.day, assignment.part, assignment.description
    );

    let did_succeed = match assignment.run() {
        Ok(None) => {
            println!("No answer given.");
            false
        }
        Err(e) => {
            println!("Error while running assignment: {}", e);
            false
        }
        Ok(Some(answer)) => {
            println!("Answer given: {}", answer);
            match assignment.answer {
                None => {
                    println!("No real answer to compare to.");
                    false
                }
                Some(real_answer) => {
                    println!("Real answer: {}", real_answer);
                    answer == real_answer
                }
            }
        }
    };

    let has_real_answer = assignment.answer != None;

    if did_succeed {
        println!("✅ Correct!");
    } else if has_real_answer {
        println!("❌ Wrong.");
    }
}
