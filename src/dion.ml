open Arg

let verbose = ref false
let command = ref "version"

let main =
    begin
        let speclist = [
            ("-v", Arg.Set verbose, "Enables verbose output");
        ] 
        in let usage = "Document processor"
        in Arg.parse speclist print_endline usage;
    end

let () = main
