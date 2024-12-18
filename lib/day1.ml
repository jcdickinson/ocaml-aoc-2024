open Core;;

let answer1 =
let r = In_channel.read_lines "inputs/day1.txt" in
let pairs = List.map ~f:(fun v -> match (String.split ~on:' ' v) |> List.filter ~f:(fun y -> not (String.is_empty y)) with
| a :: b :: [] -> (int_of_string a, int_of_string b)
| _ -> assert false) r in
let (a, b) = List.unzip pairs in
(* let a = [3;4;1;2;3;3] in *)
(* let b = [4;3;5;3;9;3] in *)
let a = List.sort ~compare:Int.ascending a in
let b = List.sort ~compare:Int.ascending b in
let l = match List.zip a b with
| Ok(l) -> l
| Unequal_lengths -> assert false in
let l = List.map ~f:(fun v  -> let (a, b) = v in a - b |> Int.abs) l in
List.fold_left ~init:0 ~f:(+) l

let answer2 =
let r = In_channel.read_lines "inputs/day1.txt" in
let pairs = List.map ~f:(fun v -> match (String.split ~on:' ' v) |> List.filter ~f:(fun y -> not (String.is_empty y)) with
| a :: b :: [] -> (int_of_string a, int_of_string b)
| _ -> assert false) r in
let (a, b) = List.unzip pairs in
(* let a = [3;4;1;2;3;3] in *)
(* let b = [4;3;5;3;9;3] in *)
let a = List.sort ~compare:Int.ascending a in
let b = List.sort ~compare:Int.ascending b in
let counts = List.map ~f:(fun a -> a * List.count ~f:(fun v -> Int.equal a v) b) a in
List.fold_left ~init:0 ~f:(+) counts

