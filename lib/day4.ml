open Core;;

let file_contents = In_channel.read_lines "inputs/day4.txt"

let build_matrix contents = Array.of_list_map ~f:String.to_array contents
let dims matrix = (Array.length (Array.get matrix 0), Array.length matrix)

let rec count_words haystack = match haystack with
  | 'X' :: 'M' :: 'A' :: 'S' :: tl -> 1 + count_words tl
  | _ :: tl -> count_words tl
  | _ -> 0

let revs list_matrix = 
  List.fold ~init:[] ~f:(fun acc row -> let lrow = List.of_array row in lrow :: List.rev lrow :: acc) list_matrix

let xy matrix x y = Array.get (Array.get matrix y) x

let build_horizontal matrix = List.of_array matrix |> List.map ~f:List.of_array

let build_vertical matrix =
  let (width, height)= dims matrix in
  List.range 0 width |> List.map ~f:(fun x ->
    List.range 0 height |> List.map ~f:(fun y -> xy matrix x y)
  )

let build_diagonal xfn matrix =
  let (width, height)= dims matrix in
    List.range (-height) (width + height) |> List.map ~f:(fun x_start ->
      List.range 0 height |> List.filter_map ~f:(fun offset ->
        let x = xfn x_start offset in
        let y = offset in
        if x >= 0 && x < width then Some(xy matrix x y)
        else None
      )
    )

let build_diagonal_1 = build_diagonal (+)
let build_diagonal_2 = build_diagonal (-)

let all_forwards matrix = 
  List.concat [
    build_horizontal matrix;
    build_vertical matrix;
    build_diagonal_1 matrix;
    build_diagonal_2 matrix;
  ]

let all_dirs matrix = let forwards = all_forwards matrix in
  List.concat [
    forwards;
    List.map ~f:List.rev forwards;
  ]
  
let answer1 contents = build_matrix contents |> all_dirs  |> List.map ~f:count_words |> List.fold ~init:0 ~f:(+)

let c_to_int c = match c with
  | 'M' -> 1
  | 'S' -> 2
  | _ -> 10

let xyc matrix x y = xy matrix x y |> c_to_int

let find_x_mas matrix =
  let (width, height)= dims matrix in
    List.range 1 (width - 1) |> List.map ~f:(fun x ->
      List.range 1 (height - 1) |> List.filter_map ~f:(fun y ->
        if phys_equal (xy matrix x y) 'A' then
          let tl = xyc matrix (x-1) (y-1) in
          let br = xyc matrix (x+1) (y+1) in
          let tr = xyc matrix (x+1) (y-1) in
          let bl = xyc matrix (x-1) (y+1) in
          let a = Int.abs (tl - br) in
          let b = Int.abs (tr - bl) in
          if phys_equal a 1 && phys_equal b 1 then Some((x, y))
          else None
        else None
      )
    )

let answer2 contents = build_matrix contents |> find_x_mas |> List.concat |> List.length
