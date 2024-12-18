open Core;;

let file_contents = In_channel.read_lines "inputs/day2.txt"

let get_numbers line = String.split ~on:' ' line
  |> List.filter ~f:(fun s -> not (phys_equal s ""))
  |> List.map ~f:int_of_string

let num_valid = Int.between ~low:1 ~high:3

let rec verify ~f list = match list with
  | x :: y :: tl -> num_valid (f x y) && verify ~f (y::tl)
  | _ -> true

let verify_decrease = verify ~f:Int.(-) 
let verify_increase = verify ~f:(fun x y -> y - x) 

let verify_either list = verify_decrease list || verify_increase list

let answer1 contents = List.map ~f:get_numbers contents
  |> List.filter ~f:verify_either
  |> List.length

let rec strip_line line = match line with
  | x :: tl -> [tl] @ List.map ~f:(fun l -> x :: l) (strip_line tl)
  | _ -> []

let verify_either2 list = strip_line list
  |> List.exists ~f:verify_either

let answer2 contents = List.map ~f:get_numbers contents
  |> List.filter ~f:verify_either2
  |> List.length

(* let nums_valid nums =  in *)
(* let filtered = List.filter ~f:nums_valid nums in *)
(* filtered *)
