def do_steps(accumulator; value):
  if value == 1 then
    accumulator
  elif value % 2 == 0 then
    do_steps(accumulator + 1; value / 2)
  else
    do_steps(accumulator + 1; value * 3 + 1)
  end
;

def steps:
  if . <= 0 then 
    "Only positive integers are allowed" | halt_error
  else
    do_steps(0; .)
  end
  ;

