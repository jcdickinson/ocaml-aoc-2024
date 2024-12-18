open Core;;

let file_contents = In_channel.read_all "inputs/day3.txt"

let rec next_mul_arg ?(matched=[]) strs delim = match strs with
  | c :: tl -> if Char.is_digit c then next_mul_arg ~matched:(c :: matched) tl delim
    else if phys_equal c delim then (Some(List.rev matched), tl)
    else (None, tl)
  | [] -> (None, [])

let to_int strs = let s = String.of_list strs in (Printf.printf "%s\n" s; int_of_string s)

let rec next_mul strs = match strs with
  'm' :: 'u' :: 'l' :: '(' :: tl -> (match next_mul_arg tl ',' with 
    (Some(a), second) -> (match next_mul_arg second ')' with
      | (Some(b), remainder) -> ((to_int a) * (to_int b)) + next_mul remainder
      | _ -> next_mul tl)
    | _ -> next_mul tl)
  | _ :: tl -> next_mul tl
  | _ -> 0

let find_valid contents = 
  let contents = String.to_list contents in
    next_mul contents

let answer1 contents = find_valid contents

let rec next_mul2 ?(enabled=true) strs = match strs with
  'm' :: 'u' :: 'l' :: '(' :: tl -> (match next_mul_arg tl ',' with 
    (Some(a), second) -> (match next_mul_arg second ')' with
      | (Some(b), remainder) -> (if enabled then ((to_int a) * (to_int b)) else 0) + next_mul2 remainder ~enabled
      | _ -> next_mul2 tl ~enabled)
    | _ -> next_mul2 tl ~enabled)
  | 'd' :: 'o' :: '(' :: ')' :: tl -> next_mul2 tl ~enabled:true
  | 'd' :: 'o' :: 'n' :: '\'' :: 't' :: '(' :: ')' :: tl -> next_mul2 tl ~enabled:false
  | _ :: tl -> next_mul2 tl ~enabled
  | _ -> 0

let find_valid2 contents = 
  let contents = String.to_list contents in
    next_mul2 contents

let answer2 contents = find_valid2 contents
