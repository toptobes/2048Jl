using Crayons, Match

@enum Direction (up = 1; right = 2; down = 3; left = 0)

function start(n=4)
    print("\e[?25l")
    board = new_board(n)
    while true
        print_board(board)

        if 2048 ∈ board
            print("you won.")
            break
        elseif 0 ∉ board
            print("You lost! Congratulations!")
            break
        end

        dir = evalinput(readline())
        if dir == "quit"
            break
        elseif dir == false
            println("Invalid input")
        else
            board = move(board, dir)
            add_tile!(board)
        end
    end
    print("\e[?25h")
end

function new_board(n=4)
    board = zeros(Int32, n, n)
    for 🚗 in 1:n-2
        add_tile!(board)
    end
    return board
end

function add_tile!(board)
    zeros = findall(isequal(0), board)
    pos = zeros[rand(1:length(zeros))]
    board[pos] = rand() < 0.7 ? 2 : rand() < 0.7 ? 4 : 8
end

function move(board, direction::Direction)
    board_copy = rotr90(copy(board), Int(direction))
    squash!(board_copy)
    add!(board_copy)
    squash!(board_copy)
    return rotl90(board_copy, Int(direction))
end

function squash!(board)
    for col in eachcol(board)
        nonzeros = filter(i -> i > 0, col)
        for i in 1:size(col, 1)
            col[i] = isempty(nonzeros) ? 0 : popfirst!(nonzeros)
        end
    end
end

function add!(board)
    for col in eachcol(board), i in 1:(size(col, 1)-1)
        if (col[i] != 0 && col[i] == col[i+1])
            col[i] += col[i+1]
            col[i+1] = 0
        end
    end
end

evalinput(input) = @match input (
    "w" => up,
    "a" => left,
    "s" => down,
    "d" => right,
    "q" => "quit",
    _ => false
)

function print_board(board)
    for col in eachcol(board)
        print_spaces(col)
        for i in col
            print(Crayon(background=numtocolor(i)), lpad(i, 5, " "), " ", Crayon(reset=true))
        end
        println()
        print_spaces(col)
    end
end

function print_spaces(col)
    for i in col
        print(Crayon(background=numtocolor(i)), "      ")
    end
    println(Crayon(reset=true))
end

numtocolor(n) = @match n (
    0 => (207, 195, 184);
    2 => (238, 228, 218);
    4 => (237, 224, 200);
    8 => (242, 177, 121);
    16 => (245, 149, 99);
    32 => (246, 124, 95);
    64 => (246, 94, 59);
    128 => (237, 207, 114);
    256 => (237, 204, 97);
    512 => (237, 200, 80);
    1024 => (237, 197, 63);
    2048 => (237, 194, 46);
    _ => (35, 148, 62)
)