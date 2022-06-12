mod assignments;
mod helpers;
use assignments::get_assignments;

fn throw_invalid_assignment_number_error() -> ! {
    println!("Invalid assignment number.");
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
    match assignment.run() {
        Ok(Some(answer)) => println!("{}", answer),
        Ok(None) => println!("No answer"),
        Err(e) => println!("Error: {}", e),
    }
}
