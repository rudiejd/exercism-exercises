pub fn collatz(n: u64) -> Option<u64> {
    if n <= 0 {
       return None;
    }

    let mut steps = 0;
    let mut collatz = n;

    while collatz != 1 {
        if collatz % 2 == 0 {
            collatz /= 2;
        } else {
            collatz = collatz * 3 + 1;
        }
        steps += 1;
    }
    Some(steps)
}
