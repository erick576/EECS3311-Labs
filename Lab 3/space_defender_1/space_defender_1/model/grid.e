note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create
	make

feature {NONE} -- Initialization

	make
			-- create new grid for the model
		do
			row_size := 0
			col_size := 0

			player_move := 0
			project_move := 0

			create starfighter.make (0, 0)
			create projectiles.make (0)

			valid_command_count := 0
			error_count := 0

			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_empty

			currently_playing := false
			still_alive := true
			is_error := false

			operation_message := "Welcome to Space Defender Version 1."
			create error_message.make_empty
		end

	reset (row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		local
			start_pos : INTEGER
		do
			-- Set the row and column size
			row_size := row
			col_size := column

			-- Set the player_mov and projectile_mov
			player_move := player_mov
			project_move := project_move

			-- Set up the ceiling of the row / 2 for the default position in the grid
			start_pos := row_size
			from

			until
				(start_pos * 2 = row_size) or (((start_pos - 1) * 2) + 1 = row_size)
			loop
				start_pos := start_pos - 2
			end

			-- Use the set up value to set the position of the starfighter and default porjectiles (0)
			create starfighter.make (start_pos, 1)
			create projectiles.make (0)

			-- Set up the valid counts for operations and errors
			valid_command_count := 1
			error_count := 0

			-- Set up the row values and grid values in character form
			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_filled ('_', 0, row_size * col_size)
			grid_elements.force ('S', (starfighter.x * starfighter.y) )

			-- Set up boolean expression for game playing
			currently_playing := true
			still_alive := true
			is_error := false

			-- Defauly messages to be updated when operations are invoked
			create operation_message.make_empty
			create error_message.make_empty
		end

feature {NONE} -- Attributes

	row_size : INTEGER_32
	col_size : INTEGER_32

	player_move : INTEGER_32
	project_move : INTEGER_32

	starfighter : STARFIGHTER
	projectiles : ARRAYED_LIST[PROJECTILE]

	valid_command_count : INTEGER
	error_count : INTEGER

	grid_char_rows : ARRAY[CHARACTER]
	grid_elements : ARRAY[CHARACTER]

	currently_playing : BOOLEAN
	is_error : BOOLEAN
	still_alive : BOOLEAN

	operation_message : STRING
	error_message : STRING


feature {NONE} -- queries

feature {NONE} -- Helpers

feature -- Output Displays

--	display_error : STRING
--		do

--		end

	display_state : STRING
		do
			create Result.make_empty
			Result.append("state:" + valid_command_count.out + "." + error_count.out + ", ")

			if is_error = true then
				Result.append("error")
			else
				Result.append("ok")
			end
			Result.append ("%N")
		end

--	display_operation_messages : STRING
--		do

--		end

	display_grid : STRING
		local
			i, j : INTEGER
		do
			create Result.make_empty
			Result.append("  ")
			from
				i := 1
			until
				i > col_size
			loop
				if i = col_size then
					Result.append (i.out)
				else
					Result.append (i.out + " ")
				end
			end

			Result.append ("%N")

			from
				i := 1
			until
				i > row_size
			loop
				Result.append (grid_char_rows.at (i).out + " ")

				from
					j := 1
				until
					j > col_size
				loop
					if j = col_size then
						Result.append (grid_elements.at (i * j).out)
					else
						Result.append (grid_elements.at (i * j).out + " ")
					end
				end

				Result.append ("%N")
			end
		end

	display_output(state : INTEGER) : STRING
		do
			create Result.make_empty

			-- Default Greeting into the game
			if state ~ 0 then
				Result.append("  " + operation_message)

			else
				-- Display the state
				Result.append(display_state)

				-- Display Operations or errors
				if is_error = true then
					Result.append(error_message)
					Result.append("%N")
				end

				-- Display The grid is playing
				if currently_playing = true then
					Result.append(display_grid)
				end

				-- Display aftermath of turn
			end
		end

feature {ETF_COMMAND} -- commands to implement

--	turn_first_part
--		do

--		end

--	abort
--		do

--		end

--	fire
--		do

--		end

--	move
--		do

--		end

--	pass
--		do

--		end

	play (row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		do
			if currently_playing = true then
				is_error := true
				error_count := error_count + 1
				error_message := "Please end the current game before starting a new one."

			elseif player_mov > (row - 1 + column - 1) then
				is_error := true
				error_count := error_count + 1
				error_message := "Starfighter movement should not exceed row - 1 + column - 1 size of the board."
			else
				reset (row, column, player_mov, project_mov)
			end
		end
end
